# -----------------------------------------------------------------------------
# Terraform and Google Provider Configuration
#
# The caller configures the Google provider. The reusable Secret Manager module
# inherits this provider configuration and does not configure authentication.
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
# Authentication is expected to be supplied externally, such as by the
# HCP Terraform workspace. Credentials are not stored in this repository.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}
