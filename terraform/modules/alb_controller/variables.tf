variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "todo-app-eks"
}
 
variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be provisioned"
  type        = string
}

variable "aws_region" {
  default = "us-east-1"
}

variable "oidc_provider_arn" {}