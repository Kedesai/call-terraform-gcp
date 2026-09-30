# -----------------------------------------------------------------------------
# Environment-Specific Terraform Variables
#
# Environment-specific values are intentionally not stored in this repository.
#
# Values should be supplied through HCP Terraform workspace variables,
# project-level variable sets, or another approved configuration mechanism.
#
# Example local values:
#
# project_id      = "my-gcp-project"
# region          = "us-central1"
#
# bucket_name     = "my-application-bucket"
# bucket_location = "US-CENTRAL1"
# storage_class   = "STANDARD"
#
# versioning_enabled = true
#
# labels = {
#   managed_by  = "terraform"
#   environment = "dev"
#   application = "example"
# }
#
# Optional CMEK:
#
# kms_key_id = "projects/.../locations/.../keyRings/.../cryptoKeys/..."
#
# Optional IAM:
#
# iam_members = [
#   "serviceAccount:application-sa@my-project.iam.gserviceaccount.com"
# ]
# -----------------------------------------------------------------------------
