# Call the VPC Module
module "vpc" {
  source = "./modules/vpc"

}

# Call the EKS Instance Module
module "eks" {
  source = "./modules/eks"
 

}

# Call the RDS Module
module "rds" {
  source = "./modules/rds"
  
}