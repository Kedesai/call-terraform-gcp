# -----------------------------------------------------------------------------
# Terraform and Provider Requirements
#
# The caller configures both providers used by this deployment:
#
# google
#   Creates and manages GCP resources through the reusable GKE module.
#
# tfe
#   Reads outputs from upstream HCP Terraform workspaces.
#
# Authentication for both providers must be supplied by the execution
# environment. Credentials and API tokens are not stored in this repository.
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.70, < 1.0"
    }
  }
}


# -----------------------------------------------------------------------------
# Google Provider
#
# Google Cloud authentication is supplied externally, such as through the
# HCP Terraform workspace execution environment.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}


# -----------------------------------------------------------------------------
# HCP Terraform Provider
#
# The TFE provider is used by data.tf to retrieve outputs from upstream HCP
# Terraform workspaces.
#
# Authentication must be supplied externally. No HCP Terraform API token is
# committed to this repository.
# -----------------------------------------------------------------------------

provider "tfe" {
  hostname = var.hcp_hostname
}
