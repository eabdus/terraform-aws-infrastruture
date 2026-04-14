variable "region" {
  default = "us-east-1"
}
variable "ami_ID" {
  default = "ami-0ec10929233384c7f"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}