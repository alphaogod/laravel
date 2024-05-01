# # EC2 Instance Jenkins
# resource "aws_instance" "jenkins_server" {
#   ami           = "ami-007020fd9c84e18c7"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

#   # Choose either public or private subnet
#   subnet_id = aws_subnet.public_subnet.id 
#   # subnet_id = aws_subnet.private_subnet.id
# }


# resource "aws_security_group" "jenkins_sg" {
#   name = "jenkins_sg"
#   vpc_id = aws_vpc.eks_vpc.id

#   ingress {
#     from_port = 22  
#     to_port   = 22
#     protocol = "tcp"
#     cidr_blocks = ["49.37.234.112/32"] 
#   }
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }