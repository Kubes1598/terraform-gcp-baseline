# terraform-gcp-baseline

A Terraform module that bootstraps a new GCP project with a VPC, IAM, audit-log sink, and a GKE Autopilot cluster skeleton. Apply takes about 4 minutes. The output is a project that looks the same every time, with no console clicks involved.

This pairs with the work I did for my Terraform Associate 003 and the GCP Professional Cloud Architect cert. I wrote it because I got tired of "new GCP project" meaning "thirty console clicks and someone always forgets the audit log sink".

## What it creates

| Resource                       | Why it's here                                          |
| ------------------------------ | ------------------------------------------------------ |
| `google_project`               | The project, attached to a billing account.            |
| `google_compute_network`       | VPC with no default routes. Explicit egress only.      |
| `google_compute_subnetwork`    | Regional subnet with secondary ranges for GKE pods.    |
| `google_compute_router` + NAT  | Egress without public IPs on workloads.                |
| `google_project_iam_binding`   | Least-privilege roles for the deployer service account.|
| `google_logging_project_sink`  | Audit logs exported to BigQuery (90-day retention).    |
| `google_bigquery_dataset`      | Sink destination, table-level expiration.              |
| `google_container_cluster`     | GKE Autopilot — no node pools to manage.               |

Twenty-three resources total. `tfsec` and `checkov` both pass.

## Using it

```hcl
module "baseline" {
  source = "github.com/Kubes1598/terraform-gcp-baseline?ref=v1.0.0"

  project_id      = "acme-platform-staging"
  billing_account = var.billing_account
  region          = "us-central1"
  environment     = "staging"
  deployer_sa     = "terraform-deployer@my-org.iam.gserviceaccount.com"
}
```

## State

Remote state in a GCS bucket with object versioning and a 90-day lifecycle policy. Locking is via Cloud Storage — no separate locking service needed.

```hcl
terraform {
  backend "gcs" {
    bucket = "acme-tfstate"
    prefix = "platform/staging"
  }
}
```

## Compliance checks in CI

The workflow in `.github/workflows/tf-plan.yml` runs on every PR:

- `terraform fmt -check` so style stays consistent.
- `tfsec` against the CIS-aligned ruleset.
- `checkov` for the CKV_GCP_* checks.
- `terraform plan` posted as a PR comment so reviewers see the actual diff before approving.

A daily scheduled run catches manual drift and posts it to Slack. If someone changes something in the console at 2am Tuesday, you find out Wednesday morning.

## Companion

- The workflows that consume the deployer service account via OIDC: [github-actions-cicd](https://github.com/Kubes1598/github-actions-cicd).
- The Helm chart you'd deploy onto the GKE cluster: [k8s-helm-observability](https://github.com/Kubes1598/k8s-helm-observability).

## License

MIT. See [LICENSE](./LICENSE).
