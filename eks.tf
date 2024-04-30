module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-058efaf2b2a8d64e1"
  subnet_ids               = ["subnet-0ceffbe2ce6f25a39", "subnet-0e3472b2af17657d8", "subnet-071e6a5b8253b0256"]
  control_plane_subnet_ids = ["subnet-076d11ee10044c8f2", "subnet-0f41d521da237a275", "subnet-0d4aa90db0764ec2f"]

  # EKS Managed Node Group
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.large", "t3.large", "t3a.medium", "t3.medium"]
  }

  eks_managed_node_groups = {
    example = {
      min_size     = 2
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }


  enable_cluster_creator_admin_permissions = true

  access_entries = {
  
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::590184096928:role/EksClusterServiceRole"

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

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}