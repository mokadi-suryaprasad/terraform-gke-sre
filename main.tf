terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "terraform-state-dev-surya"   # Replace with your actual bucket name
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}


resource "google_project_service" "api" {
  for_each = toset(local.apis)
  service  = each.key

  disable_on_destroy = false
}


module "network" {
  source              = "./modules/network"
  cluster_name        = var.cluster_name
  vpc_cidr            = var.vpc_cidr
  region              = var.region
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  k8s_pods_cidr       = var.k8s_pods_cidr       # if required by your module
  k8s_services_cidr   = var.k8s_services_cidr     # if required by your module
}


module "gke" {
  source = "./modules/gke-cluster"
  
  project         = var.project        # Added variable
  region          = var.region         # Added variable
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  network         = module.network.vpc_self_link
  subnetwork      = module.network.public_subnet_self_link
  node_groups     = var.node_groups
  # You can add more variables if your GKE module supports them
}
