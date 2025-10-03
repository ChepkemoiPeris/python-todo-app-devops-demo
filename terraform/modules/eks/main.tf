module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = var.eks_cluster_name
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  create_cni_ipv6_iam_policy = true  
  create_iam_role = true
  enable_irsa = true


  eks_managed_node_groups = {
    eks_node_instance = {
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = 1
      desired_size   = 1
 
    }

    
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = var.eks_cluster_name 
    Terraform   = "true"
  }

}