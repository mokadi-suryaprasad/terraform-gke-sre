# Create the GKE cluster
resource "google_container_cluster" "gke" {
  name                     = var.cluster_name
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  min_master_version       = var.cluster_version
  deletion_protection      = false # Disable deletion protection
  network    = var.network
  subnetwork = var.subnetwork

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
}

# Create a node service account (optional: for using Workload Identity)
resource "google_service_account" "gke_node" {
  account_id   = "${var.cluster_name}-node-sa"
  display_name = "GKE Node Service Account"
}

# Create GKE Node Pools with e2-medium and optimized disk size
resource "google_container_node_pool" "node_pool" {
  for_each = var.node_groups

  name       = each.key
  cluster    = google_container_cluster.gke.name
  location   = google_container_cluster.gke.location
  node_count = each.value.scaling_config.desired_size

  autoscaling {
    min_node_count = each.value.scaling_config.min_size
    max_node_count = each.value.scaling_config.max_size
  }

  node_config {
    machine_type   = "e2-medium"
    preemptible    = each.value.preemptible
    disk_size_gb   = 10 # Reduced disk size to avoid quota issues
    disk_type      = "pd-standard" # Using standard disks to avoid SSD quota issues
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    service_account = google_service_account.gke_node.email
  }
}
