resource "google_container_cluster" "primary" {
  provider = google-beta

  project  = google_project.this.project_id
  name     = "${var.environment}-primary"
  location = var.region

  enable_autopilot = true
  release_channel { channel = "REGULAR" }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.primary.name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${google_project.this.project_id}.svc.id.goog"
  }

  deletion_protection = var.environment == "prod"
}
