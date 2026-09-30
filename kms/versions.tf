# -----------------------------------------------------------------------------
# Terraform and Google Provider Configuration
#
# The caller module is responsible for configuring the Google provider.
# Reusable modules only declare their required provider and inherit this
# provider configuration from the caller.
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
# such as HCP Terraform. No credentials are stored in this repository.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}
