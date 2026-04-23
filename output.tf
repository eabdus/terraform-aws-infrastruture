output "private_ip" {
  value = aws_instance.web01.private_ip
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
