# -----------------------------------------------------------------------------
# Terraform and Google Provider Configuration
#
# This caller configures the Google provider.
#
# The reusable Cloud Storage module only declares its provider requirement and
# inherits this provider configuration from the caller.
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }
}


# -----------------------------------------------------------------------------
# Google Provider
#
# Authentication is expected to be supplied by the execution environment,
# such as HCP Terraform.
#
# No Google Cloud credentials are stored in this repository.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}
