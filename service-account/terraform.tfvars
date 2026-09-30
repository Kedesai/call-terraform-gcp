project_id = "my-gcp-project"
region     = "us-central1"

create_service_account = true

account_id   = "platform-sa"
display_name = "Platform Service Account"
description  = "Service account managed by Terraform."

project_roles = [
  "roles/logging.logWriter",
  "roles/monitoring.metricWriter"
]
