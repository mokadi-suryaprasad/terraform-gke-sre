variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster (used for resource naming)"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "cluster_version" {
  description = "The GKE cluster version"
  type        = string
}

variable "network" {
  description = "The self-link of the VPC network to use for the cluster"
  type        = string
}

variable "subnetwork" {
  description = "The self-link of the subnetwork to use for the cluster"
  type        = string
}

variable "node_groups" {
  description = "A map of node group configurations for the cluster"
  type = map(object({
    machine_type   = string
    preemptible    = bool
    scaling_config = object({
      desired_size = number
      min_size     = number
      max_size     = number
    })
  }))
}
