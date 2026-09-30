# -----------------------------------------------------------------------------
# Terraform and Provider Requirements
#
# google:
#   Creates the Private Service Access resources through the reusable module.
#
# tfe:
#   Retrieves the VPC network outputs from an upstream HCP Terraform workspace.
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
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
}


# -----------------------------------------------------------------------------
# HCP Terraform Provider
#
# Authentication is supplied by the HCP Terraform execution environment.
# -----------------------------------------------------------------------------

provider "tfe" {
  hostname = var.hcp_hostname
}
