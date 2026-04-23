#Region
variable "region" {
  default = "us-east-1"
}

#VPC cidr
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

#Subnet cidr
#1. Subnet public
variable "subnet_public" {
  default = "10.10.1.0/24"

}

#2. Subnet private
variable "subnet_private" {
  default = "10.10.2.0/24"
}

#AZ (Availability Zone)
#AZ1
variable "zone1" {
  default = "us-east-1a"
}
#AZ2
variable "zone2" {
  default = "us-east-1b"
}

#AMI (OS)
#Ubuntu 24.0
variable "ami_ID" {
  default = "ami-0ec10929233384c7f"
}

#Instance
variable "instance_type" {
  default = "t2.micro"
}