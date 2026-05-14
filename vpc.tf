resource "google_compute_network" "vpc" {
  project                         = google_project.this.project_id
  name                            = "${var.environment}-vpc"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  depends_on                      = [google_project_service.enabled]
}

resource "google_compute_subnetwork" "primary" {
  project       = google_project.this.project_id
  name          = "${var.environment}-primary"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "nat" {
  project = google_project.this.project_id
  name    = "${var.environment}-nat-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  project                            = google_project.this.project_id
  name                               = "${var.environment}-nat"
  router                             = google_compute_router.nat.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_route" "egress" {
  project          = google_project.this.project_id
  name             = "${var.environment}-egress"
  network          = google_compute_network.vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}
