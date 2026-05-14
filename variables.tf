variable "project_id" {
  description = "GCP project ID. Must be globally unique."
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{5,29}$", var.project_id))
    error_message = "project_id must be 6-30 chars, lowercase, start with a letter."
  }
}

variable "billing_account" {
  description = "Billing account to attach the project to."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Primary region for regional resources."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment label (dev, staging, prod)."
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "deployer_sa" {
  description = "Email of the deployer service account that needs Editor on this project."
  type        = string
}

variable "subnet_cidr" {
  description = "Primary subnet CIDR."
  type        = string
  default     = "10.10.0.0/20"
}

variable "pods_cidr" {
  description = "Secondary range for GKE pods."
  type        = string
  default     = "10.20.0.0/14"
}

variable "services_cidr" {
  description = "Secondary range for GKE services."
  type        = string
  default     = "10.24.0.0/20"
}
