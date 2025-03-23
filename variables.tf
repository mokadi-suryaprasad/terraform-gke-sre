variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster (used for naming resources)"
  type        = string
}

variable "cluster_version" {
  description = "The version of the GKE cluster"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC network"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}
variable "k8s_pods_cidr" {
  description = "CIDR block for Kubernetes pods (secondary range in the private subnet)"
  type        = string
}

variable "k8s_services_cidr" {
  description = "CIDR block for Kubernetes services (secondary range in the private subnet)"
  type        = string
}


variable "service_account_email" {
  description = "Email address of the service account to be granted IAM roles."
  type        = string
}

variable "node_groups" {
  description = "Map of node group configurations for the cluster"
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
