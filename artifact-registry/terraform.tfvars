# -----------------------------------------------------------------------------
# Environment-Specific Terraform Variables
#
# Environment-specific configuration is intentionally not stored in this
# repository.
#
# Values should be supplied through HCP Terraform workspace variables,
# project-level variable sets, or another approved configuration mechanism.
#
# Example values for local testing:
#
# project_id = "my-gcp-project"
# region     = "us-central1"
#
# repository_id       = "application-images"
# repository_location = "us-central1"
# repository_format   = "DOCKER"
#
# description    = "Application container images"
# immutable_tags = true
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
# Optional repository IAM:
#
# iam_role = "roles/artifactregistry.reader"
#
# iam_members = [
#   "serviceAccount:application@my-project.iam.gserviceaccount.com"
# ]
# -----------------------------------------------------------------------------
