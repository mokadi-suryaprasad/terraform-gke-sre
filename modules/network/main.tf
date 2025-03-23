# Create a VPC network with regional routing and no auto subnet creation
resource "google_compute_network" "vpc" {
  name                    = var.cluster_name
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

# Create a public subnetwork
resource "google_compute_subnetwork" "public" {
  name                     = "${var.cluster_name}-public"
  ip_cidr_range            = var.public_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

# Create a private subnetwork with secondary ranges for Pods and Services
resource "google_compute_subnetwork" "private" {
  name                     = "${var.cluster_name}-private"
  ip_cidr_range            = var.private_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pods"
    ip_cidr_range = var.k8s_pods_cidr
  }

  secondary_ip_range {
    range_name    = "k8s-services"
    ip_cidr_range = var.k8s_services_cidr
  }
}

# Reserve an external static IP for NAT Gateway
resource "google_compute_address" "nat" {
  name         = "${var.cluster_name}-nat"
  region       = var.region
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

# Create a Cloud Router for NAT
resource "google_compute_router" "router" {
  name    = "${var.cluster_name}-router"
  region  = var.region
  network = google_compute_network.vpc.self_link
}

# Configure Cloud NAT using the router and static IP
resource "google_compute_router_nat" "nat" {
  name                               = "${var.cluster_name}-nat"
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Route to allow internet access from public subnet
resource "google_compute_route" "public_internet" {
  name             = "${var.cluster_name}-public-default-route"
  network          = google_compute_network.vpc.self_link
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}
