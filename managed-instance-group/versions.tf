# -----------------------------------------------------------------------------
# Terraform and Provider Requirements
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
# Authentication is supplied by the HCP Terraform execution environment.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}


# -----------------------------------------------------------------------------
# HCP Terraform Provider
# -----------------------------------------------------------------------------

provider "tfe" {
  hostname = var.hcp_hostname
}
