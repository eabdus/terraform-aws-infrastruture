# resource "aws_security_group" "web01-sg" {
#   name        = "web01-sg"
#   description = "Allow TLS inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.ead-vpc.id
#   tags = {
#     Name = "web01-sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow-SSH" {
#   security_group_id = aws_security_group.web01-sg.id
#   cidr_ipv4         = "182.6.5.143/32"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_ingress_rule" "allowtraffic" {
#   security_group_id = aws_security_group.web01-sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.web01-sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
#   security_group_id = aws_security_group.web01-sg.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }