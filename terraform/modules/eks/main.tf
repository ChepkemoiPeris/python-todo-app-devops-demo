module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = var.eks_cluster_name
  kubernetes_version = "1.33"

  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    example = {
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = 2
      desired_size   = 2

      additional_security_group_ids = var.eks_nodes_sg_id
    }

    
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = var.eks_cluster_name 
    Terraform   = "true"
  }

}