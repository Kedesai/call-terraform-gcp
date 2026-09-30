# -----------------------------------------------------------------------------
# Terraform and Google Provider Configuration
#
# This caller configures the Google provider.
#
# The reusable VM module declares its provider requirement but inherits the
# provider configuration and authentication from this caller.
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
# Authentication is expected to be supplied externally, such as through
# HCP Terraform.
#
# Credentials are intentionally not stored in this repository.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}
