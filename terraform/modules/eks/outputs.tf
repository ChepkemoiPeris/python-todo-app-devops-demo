output "cluster_name" {
  value       = module.eks.cluster_name
  description = "The name of the created EKS cluster."
}
 

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The endpoint for the EKS Kubernetes API server."
}
output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider for IRSA"
  value       = module.eks.oidc_provider_arn
}
