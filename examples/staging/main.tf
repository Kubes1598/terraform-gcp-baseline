terraform {
  backend "gcs" {
    bucket = "acme-tfstate"
    prefix = "platform/staging"
  }
}

module "baseline" {
  source = "../.."

  project_id      = "acme-platform-staging"
  billing_account = var.billing_account
  region          = "us-central1"
  environment     = "staging"
  deployer_sa     = "terraform-deployer@my-org.iam.gserviceaccount.com"
}

variable "billing_account" {
  type      = string
  sensitive = true
}

output "cluster" {
  value = module.baseline.cluster_name
}
