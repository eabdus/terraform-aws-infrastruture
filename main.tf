provider "aws" {
  region = "us-east-1"
}
#Create VPC
resource "aws_vpc" "ead-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ead-vpc"
  }
}
#Create Subnet
resource "aws_subnet" "ead_subnet" {
  vpc_id     = aws_vpc.ead-vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "ead_subnet"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "ead-gw" {
  vpc_id = aws_vpc.ead-vpc.id

  tags = {
    Name = "main"
  }
}

#Create Route Table
resource "aws_route_table" "ead-rt" {
  vpc_id = aws_vpc.ead-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ead-gw.id
  }

  tags = {
    Name = "ead-rt"
  }
}

#Create Route Tabel Acossiation with Route Table
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.ead_subnet.id
  route_table_id = aws_route_table.ead-rt.id
}

#Create EC2 Instance
resource "aws_instance" "web01" {
  ami             = var.ami_iD
  instance_type   = var.instance_type
  key_name        = aws_key_pair.demokey.key_name
  vpc_security_group_ids = [ aws_security_group.web01-sg.id ]
  subnet_id       = aws_subnet.ead_subnet.id 

  tags = {
    Name = "web01"
  }

}
