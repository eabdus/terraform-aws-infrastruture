#Region
provider "aws" {
  region = var.region
}

#Create VPC
resource "aws_vpc" "ead_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "ead-vpc"
  }
}

#Create Subnet
#1. Subnet public
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.ead_vpc.id
  cidr_block              = var.subnet_public
  map_public_ip_on_launch = "true"
  availability_zone       = var.zone1


  tags = {
    Name = "subnet_public"
  }
}

#2. subnet private
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.ead_vpc.id
  cidr_block        = var.subnet_private
  availability_zone = var.zone2


  tags = {
    Name = "subnet_private"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "ead_gw" {
  vpc_id = aws_vpc.ead_vpc.id

  tags = {
    Name = "ead-gw"
  }
}

#Create Route Table Public
#1. Route table public
resource "aws_route_table" "ead_rtpublic" {
  vpc_id = aws_vpc.ead_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ead_gw.id
  }

  tags = {
    Name = "ead_rt"
  }
}

#2. Route table private
resource "aws_route_table" "ead_rtprivate" {
  vpc_id = aws_vpc.ead_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "ead_rt"
  }
}

#3. Route Tabel Acossiation for public
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.ead_rtpublic.id
}

#4. Route Tabel Acossiation for private
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.ead_rtprivate.id
}

#Create Elastic IP
#1. Elastic ip for nat gateway
resource "aws_eip" "eip_nat" {
  domain = "vpc"
}

#3. Elastic ip for bastion instance
resource "aws_eip" "bastion_eip" {
  domain = "vpc"
}

#4. Elastic IP association for bastion instance
resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_eip.id
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "NAT-gw"
  }
  depends_on = [aws_internet_gateway.ead_gw]
}

#Create EC2 Instance
#1. EC2 Instance "Private"
resource "aws_instance" "web01" {
  ami                    = var.ami_ID
  instance_type          = var.instance_type
  key_name               = aws_key_pair.demokey.key_name
  vpc_security_group_ids = [aws_security_group.web01_sg.id]
  subnet_id              = aws_subnet.private.id


  tags = {
    Name = "web01"
  }
}

#2. EC2 Instance "Bastion"
resource "aws_instance" "bastion" {
  ami                    = var.ami_ID
  instance_type          = var.instance_type
  key_name               = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = aws_subnet.public.id

  tags = {
    Name = "bastion"
  }
}

