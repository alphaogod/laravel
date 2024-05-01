# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"

  name                 = "my-vpc"
  cidr                 = "172.31.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]  
  private_subnets      = ["172.31.1.0/24", "172.31.2.0/24","172.31.3.0/24"]
  public_subnets       = ["172.31.4.0/24", "172.31.5.0/24","172.31.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "dev"
  }
}