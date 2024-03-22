# #sg for jenkins
# resource "aws_security_group" "jenkins_sg" {
#   name = "jenkins_sg"
#   vpc_id = aws_vpc.eks_vpc.id  #same vpc as eks

#   ingress {
#     from_port = 22  # SSH access
#     to_port   = 22
#     protocol = "tcp"
#     cidr_blocks = ["49.37.234.112/32"]  #my ip address
#   }

#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
