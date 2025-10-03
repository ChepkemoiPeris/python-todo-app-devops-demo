# EKS Cluster Variables

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "todo-app-eks"
}
 
variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be provisioned"
  type        = string
}
 
variable "private_subnet_ids" {
  description = "List of private subnet IDs for worker nodes"
  type        = list(string)
}
 

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}
 
 
