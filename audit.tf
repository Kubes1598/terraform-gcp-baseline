resource "google_bigquery_dataset" "audit_logs" {
  project                    = google_project.this.project_id
  dataset_id                 = "audit_logs"
  friendly_name              = "Audit Logs"
  description                = "Cloud Audit Logs exported via Logging sink."
  location                   = "US"
  default_table_expiration_ms = 7776000000

  labels = {
    environment = var.environment
    purpose     = "audit"
  }
}

resource "google_logging_project_sink" "audit_to_bq" {
  project                = google_project.this.project_id
  name                   = "audit-${var.environment}"
  destination            = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.audit_logs.dataset_id}"
  filter                 = "logName:\"cloudaudit.googleapis.com\""
  unique_writer_identity = true
}

resource "google_bigquery_dataset_iam_member" "audit_writer" {
  project    = google_project.this.project_id
  dataset_id = google_bigquery_dataset.audit_logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.audit_to_bq.writer_identity
}
