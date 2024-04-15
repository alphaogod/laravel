# Create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"

  name                 = "my-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b"]  # Replace with your desired availability zones
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]  # Replace with your desired private subnet CIDRs
  public_subnets       = ["10.0.3.0/24", "10.0.4.0/24"]  # Replace with your desired public subnet CIDRs
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "dev"
  }
}