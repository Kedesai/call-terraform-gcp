# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID where the Artifact Registry repository is created."
  type        = string
}

variable "region" {
  description = "Default GCP region used by the Google provider."
  type        = string
  default     = "us-central1"
}


# -----------------------------------------------------------------------------
# Artifact Registry Repository Configuration
#
# repository_id is the actual Artifact Registry repository name.
#
# repository_location is kept separate from the provider region so the
# repository can use a different regional or multi-regional location.
# -----------------------------------------------------------------------------

variable "repository_id" {
  description = "Artifact Registry repository ID."
  type        = string
}

variable "repository_location" {
  description = "Location of the Artifact Registry repository."
  type        = string
  default     = "us-central1"
}

variable "repository_format" {
  description = "Artifact Registry repository format."
  type        = string
  default     = "DOCKER"

  validation {
    condition = contains(
      [
        "DOCKER",
        "MAVEN",
        "NPM",
        "PYTHON",
        "APT",
        "YUM",
        "GO",
        "GENERIC"
      ],
      upper(var.repository_format)
    )

    error_message = "repository_format must be DOCKER, MAVEN, NPM, PYTHON, APT, YUM, GO, or GENERIC."
  }
}

variable "description" {
  description = "Description of the Artifact Registry repository."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Docker Configuration
#
# immutable_tags is relevant to Docker repositories.
#
# When enabled, existing Docker tags cannot be moved to another image digest.
# The reusable module only creates docker_config for DOCKER repositories.
# -----------------------------------------------------------------------------

variable "immutable_tags" {
  description = "Enable immutable Docker tags."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Customer-Managed Encryption Key
#
# We use kms_key_id consistently across our GCP callers.
#
# KMS caller output:
#
#   crypto_key_id
#
# Artifact Registry caller input:
#
#   kms_key_id
#
# The caller translates this to kms_key_name when calling the reusable module.
#
# Leave null when CMEK is not required.
# -----------------------------------------------------------------------------

variable "kms_key_id" {
  description = "Optional fully qualified Cloud KMS Crypto Key ID used for Artifact Registry CMEK."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Labels
# -----------------------------------------------------------------------------

variable "labels" {
  description = "Labels applied to the Artifact Registry repository."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}


# -----------------------------------------------------------------------------
# Repository-Level IAM
#
# IAM is optional.
#
# When iam_members is empty, the caller passes no repository IAM bindings to
# the reusable module.
# -----------------------------------------------------------------------------

variable "iam_role" {
  description = "Artifact Registry repository IAM role assigned to iam_members."
  type        = string
  default     = "roles/artifactregistry.reader"
}

variable "iam_members" {
  description = "IAM members granted repository access."
  type        = set(string)
  default     = []
}
