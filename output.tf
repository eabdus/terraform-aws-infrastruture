output "instance_type" {
  value = aws_instance.web01.id
}

output "public_ip" {
  value = aws_instance.web01.public_ip
}