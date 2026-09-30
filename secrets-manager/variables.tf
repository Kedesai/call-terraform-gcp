# -----------------------------------------------------------------------------
# GCP Project Configuration
#
# Defines the GCP project and default region used by this caller.
# The Google provider configuration in versions.tf consumes these values.
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID where the Secret Manager resource is created."
  type        = string
}

variable "region" {
  description = "Default GCP region used by the Google provider."
  type        = string
  default     = "us-central1"
}


# -----------------------------------------------------------------------------
# Secret Configuration
#
# secret_id is the actual Secret Manager secret name created in GCP.
#
# This Terraform deployment manages the secret container and configuration.
# Secret payloads are intentionally not accepted by this caller.
# -----------------------------------------------------------------------------

variable "secret_id" {
  description = "Name of the Secret Manager secret."
  type        = string
}


# -----------------------------------------------------------------------------
# Secret Replication Configuration
#
# Supported replication strategies:
#
# AUTOMATIC
#   Google manages the secret replica placement.
#
# USER_MANAGED
#   The caller specifies one or more replica locations.
# -----------------------------------------------------------------------------

variable "replication_type" {
  description = "Secret replication strategy: AUTOMATIC or USER_MANAGED."
  type        = string
  default     = "AUTOMATIC"

  validation {
    condition = contains(
      ["AUTOMATIC", "USER_MANAGED"],
      upper(var.replication_type)
    )

    error_message = "replication_type must be AUTOMATIC or USER_MANAGED."
  }
}


# -----------------------------------------------------------------------------
# Customer-Managed Encryption Key (CMEK)
#
# kms_key_id optionally supplies a fully qualified Cloud KMS Crypto Key ID.
#
# This naming intentionally matches the crypto_key_id output exposed by our
# KMS caller. This provides a consistent interface between service callers:
#
# KMS caller:
#   crypto_key_id
#
# Secret Manager caller:
#   kms_key_id
#
# Leave this variable null to use the default encryption behavior.
#
# This variable applies to AUTOMATIC replication. For USER_MANAGED replication,
# each replica can provide its own location-compatible KMS key.
# -----------------------------------------------------------------------------

variable "kms_key_id" {
  description = "Optional fully qualified Cloud KMS Crypto Key ID used for Secret Manager CMEK."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# User-Managed Replication
#
# Used only when:
#
# replication_type = "USER_MANAGED"
#
# Each replica specifies a GCP location and can optionally specify its own
# location-compatible Cloud KMS Crypto Key.
#
# The reusable module performs additional validation of the replication
# configuration.
# -----------------------------------------------------------------------------

variable "user_managed_replicas" {
  description = "Replica configuration used when USER_MANAGED replication is selected."

  type = list(object({
    location     = string
    kms_key_name = optional(string)
  }))

  default = []
}


# -----------------------------------------------------------------------------
# Secret Labels
#
# Labels provide metadata that can be used for environment identification,
# ownership, automation and resource organization.
# -----------------------------------------------------------------------------

variable "labels" {
  description = "Labels applied to the Secret Manager secret."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}


# -----------------------------------------------------------------------------
# Secret-Level IAM Configuration
#
# IAM access is optional.
#
# When iam_members is empty, no secret-level IAM grants are created.
#
# The default role grants Secret Manager secret accessor permissions.
# Callers can override the role when a different secret-level role is needed.
# -----------------------------------------------------------------------------

variable "iam_role" {
  description = "Secret-level IAM role assigned to iam_members."
  type        = string
  default     = "roles/secretmanager.secretAccessor"
}

variable "iam_members" {
  description = "IAM members granted access to the secret."
  type        = set(string)
  default     = []
}
