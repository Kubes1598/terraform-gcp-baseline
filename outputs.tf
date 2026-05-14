output "project_id" {
  value       = google_project.this.project_id
  description = "Created project ID."
}

output "network" {
  value       = google_compute_network.vpc.name
  description = "VPC network name."
}

output "subnet" {
  value       = google_compute_subnetwork.primary.name
  description = "Primary subnet name."
}

output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Autopilot cluster name."
}

output "cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE master endpoint (private)."
  sensitive   = true
}

output "audit_dataset" {
  value       = google_bigquery_dataset.audit_logs.dataset_id
  description = "BigQuery dataset receiving audit logs."
}
