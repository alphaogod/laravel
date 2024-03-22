resource "aws_security_group" "eks_cluster_sg" {
  name = "eks_cluster_sg"
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "eks_cluster_sg_inbound_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port   = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.eks_cluster_sg.id
}
