# -----------------------------------------------------------------------------
# Terraform and Provider Requirements
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0, < 9.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.70, < 1.0"
    }
  }
}


# -----------------------------------------------------------------------------
# Google Provider
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
}


# -----------------------------------------------------------------------------
# HCP Terraform Provider
# -----------------------------------------------------------------------------

provider "tfe" {
  hostname = var.hcp_hostname
}
