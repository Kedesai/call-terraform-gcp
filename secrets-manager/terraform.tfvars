# -----------------------------------------------------------------------------
# Environment-Specific Terraform Variables
#
# Environment-specific values are intentionally not stored in this repository.
# Values are expected to be supplied by HCP Terraform workspace or
# project-level variable sets.
#
# Example values for local testing:
#
# project_id = "my-gcp-project"
# region     = "us-central1"
#
# secret_id        = "application-secret"
# replication_type = "AUTOMATIC"
#
# labels = {
#   managed_by  = "terraform"
#   environment = "dev"
#   application = "example"
# }
#
# Optional CMEK:
#
# kms_key_name = "projects/.../locations/.../keyRings/.../cryptoKeys/..."
#
# Optional IAM:
#
# iam_members = [
#   "serviceAccount:application-sa@my-gcp-project.iam.gserviceaccount.com"
# ]
# -----------------------------------------------------------------------------
