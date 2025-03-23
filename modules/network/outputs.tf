output "vpc_self_link" {
  description = "The self-link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "public_subnet_self_link" {
  description = "The self-link of the public subnet"
  value       = google_compute_subnetwork.public.self_link
}

output "private_subnet_self_link" {
  description = "The self-link of the private subnet"
  value       = google_compute_subnetwork.private.self_link
}
