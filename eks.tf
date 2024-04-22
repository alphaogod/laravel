# Create an EKS cluster

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.29" 
  cluster_endpoint_public_access  = true
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  
  eks_managed_node_groups = {
    my_node_group = {
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 1
      instance_type    = "t3a.medium"
      enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::590184096928:role/AmazonEKSNodeRole"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

      authentication_mode = "API_AND_CONFIG_MAP"
      cluster_endpoint_public_access  = true

    }
  }
}