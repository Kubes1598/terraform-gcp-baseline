resource "google_project" "this" {
  name            = var.project_id
  project_id      = var.project_id
  billing_account = var.billing_account
  labels = {
    environment = var.environment
    managed-by  = "terraform"
  }
}

locals {
  required_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "bigquery.googleapis.com",
  ]
}

resource "google_project_service" "enabled" {
  for_each = toset(local.required_apis)
  project  = google_project.this.project_id
  service  = each.value

  disable_dependent_services = true
  disable_on_destroy         = false
}
