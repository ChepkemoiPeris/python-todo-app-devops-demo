# Call the VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  vpc_tags = var.vpc_tags
  vpc_public_subnets  = var.vpc_public_subnets
  vpc_private_subnets = var.vpc_private_subnets
  vpc_database_subnets = var.vpc_database_subnets
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
 
  vpc_name           = var.vpc_name
  vpc_private_subnets = var.vpc_private_subnets
}

# Call the EKS Instance Module
module "eks" {
  source = "./modules/eks"
 
  vpc_id              = module.vpc.vpc_id
  eks_nodes_sg_id     = [module.security_groups.eks_nodes_sg_id]
  private_subnet_ids  = module.vpc.private_subnets 
}

# Call the RDS Module
module "rds" {
  source = "./modules/rds"
  
  #vpc_id              = module.vpc.vpc_id
  #db_subnet_group_id  = module.vpc.database_subnet_group
  #db_security_group   = module.security_groups.rds_sg_id
}