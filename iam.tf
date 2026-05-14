resource "google_project_iam_member" "deployer_editor" {
  project = google_project.this.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${var.deployer_sa}"
}

resource "google_project_iam_member" "deployer_iam_admin" {
  project = google_project.this.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${var.deployer_sa}"
}

resource "google_project_iam_audit_config" "all" {
  project = google_project.this.project_id
  service = "allServices"

  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}
