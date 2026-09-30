# -----------------------------------------------------------------------------
# Terraform and Provider Requirements
#
# google:
#   Creates Pub/Sub resources through the reusable module.
#
# tfe:
#   Retrieves outputs from optional upstream HCP Terraform workspaces.
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
# GCP authentication is supplied by the execution environment.
# -----------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}


# -----------------------------------------------------------------------------
# HCP Terraform Provider
#
# Authentication is supplied externally. No HCP Terraform token is stored in
# this repository.
# -----------------------------------------------------------------------------

provider "tfe" {
  hostname = var.hcp_hostname
}
