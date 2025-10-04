# Root outputs.tf

# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "database_subnets" {
  description = "The database subnet IDs for RDS"
  value       = module.vpc.database_subnets
}

output "database_subnet_group_name" {
  description = "The database subnet group name for RDS"
  value       = module.vpc.database_subnet_group_name
}

# EKS Outputs
output "cluster_name" {
  description = "The name of the created EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

# RDS Outputs
output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.rds_endpoint
}

output "rds_port" {
  description = "The port of the RDS instance"
  value       = module.rds.rds_port
}
output "rds_host" {
  description = "RDS hostname without port"
  value       = module.rds.rds_host
}