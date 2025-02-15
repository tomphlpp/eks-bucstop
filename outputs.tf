output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The API server endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "The security group ID of the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "helm_release_status" {
  description = "The status of the Helm release"
  value       = helm_release.bucstop.status
}

output "helm_release_namespace" {
  description = "The namespace where the Helm release was deployed"
  value       = helm_release.bucstop.namespace
}

output "helm_release_version" {
  description = "The version of the Helm chart that was deployed"
  value       = helm_release.bucstop.chart
}


