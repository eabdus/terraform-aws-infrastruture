provider "aws" {
  region = var.region
}

#Create VPC
resource "aws_vpc" "ead-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ead-vpc"
  }
}

#Create Subnet public
resource "aws_subnet" "ead_subnet" {
  vpc_id     = aws_vpc.ead-vpc.id
  cidr_block = "10.10.1.0/24"


  tags = {
    Name = "ead_subnet"
  }
}

#Create Subnet Private
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.ead-vpc.id
  cidr_block = "10.10.2.0/24"
  
}

#Create Internet Gateway
resource "aws_internet_gateway" "ead-gw" {
  vpc_id = aws_vpc.ead-vpc.id

  tags = {
    Name = "ead-gw"
  }
}

#Create Route Table Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ead-vpc.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ead-gw.id
}

#Create Route Table Private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ead-vpc.id
}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
  
}

#Create Route Tabel Acossiation with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.ead_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Create Elastic IP for nat
resource "aws_eip" "nat" {
  domain = "vpc"
  
}

# Create Elastic IP for bastion
resource "aws_eip" "bastion" {
  domain = "vpc"
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.ead_subnet.id

  depends_on = [ aws_internet_gateway.ead-gw ]
}

#Create EC2 Instance "Private"
resource "aws_instance" "web01" {
  ami                    = var.ami_ID
  instance_type          = var.instance_type
  key_name               = aws_key_pair.demokey.key_name
  vpc_security_group_ids = [aws_security_group.web01-sg.id]
  subnet_id              = aws_subnet.private.id

  tags = {
    Name = "web01"
  }
}

#Create EC2 Instance "Bastion"
resource "aws_instance" "bastion" {
  ami                         = var.ami_ID
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bastion.key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = aws_subnet.ead_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}

resource "aws_eip_association" "bastion" {
  instance_id = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}