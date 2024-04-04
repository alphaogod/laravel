resource "aws_eks_cluster" "my_eks_cluster" {
  name = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    subnet_ids = subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Add node group configuration
# Node Group Configuration
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_eks_cluster.name
  node_group_name = "laravel"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]  # Adjust subnet IDs as needed
  instance_types  = ["t3a.medium"]  # Adjust instance types as needed

  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 1
  }
}

# Add IAM role for nodes
resource "aws_iam_role" "node_group_role" {
  name               = "eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role.json
}

data "aws_iam_policy_document" "node_group_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Add security group for nodes
resource "aws_security_group" "node_security_group" {
  name        = "eks-node-security-group"
  vpc_id      = aws_vpc.eks_vpc.id
  # Add rules to allow inbound and outbound traffic as needed
}

resource "aws_iam_instance_profile" "node_profile" {
  name = "my-node-profile"
  role = aws_iam_role.node_group_role.name
}

# Add node configuration
resource "aws_launch_configuration" "my_launch_configuration" {
  name_prefix              = "eks-node-launch-config-"
  image_id                 = "ami-007020fd9c84e18c7"  # Specify the appropriate AMI
  instance_type            = "t3a.medium"  # Adjust instance type as needed
  iam_instance_profile     = aws_iam_instance_profile.node_profile.name
  security_groups          = [aws_security_group.node_security_group.id]
  associate_public_ip_address = true  # Enable if nodes need public IP addresses
}

# Add auto scaling configuration
resource "aws_autoscaling_group" "my_autoscaling_group" {
  launch_configuration = aws_launch_configuration.my_launch_configuration.name
  min_size              = 1
  max_size              = 10
  desired_capacity      = 1
  vpc_zone_identifier   = [aws_subnet.public_subnet.id]  # Specify the subnet IDs
}

