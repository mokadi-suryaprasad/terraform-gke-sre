output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.gke.endpoint
}

output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.gke.name
}
