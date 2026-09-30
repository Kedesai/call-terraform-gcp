# -----------------------------------------------------------------------------
# Terraform and Provider Requirements
#
# Provider configuration and authentication belong to the caller.
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
# Authentication is supplied by the HCP Terraform execution environment.
# Credentials are not stored in this repository.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
}
