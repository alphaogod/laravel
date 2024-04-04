module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.28"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1

      instance_type = "t3a.medium"
      key_name      = "laravelnew.pem"

      additional_tags = {
        Environment = "test"
        Name        = "eks-worker-node"
      }
    }
  }
}
