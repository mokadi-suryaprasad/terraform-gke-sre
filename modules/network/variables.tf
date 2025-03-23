variable "cluster_name" {
  description = "The name for the cluster (and used for naming the VPC and subnets)"
  type        = string
}

variable "region" {
  description = "The GCP vpc_region where resources will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR for the VPC network (for reference; subnets determine actual CIDRs in GCP)"
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
