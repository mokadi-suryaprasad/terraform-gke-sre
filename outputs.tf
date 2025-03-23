output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = module.gke.cluster_endpoint
}

output "cluster_name" {
  description = "GKE cluster name"
  value       = module.gke.cluster_name
}

output "vpc_id" {
  description = "VPC network self-link"
  value       = module.network.vpc_self_link
}
