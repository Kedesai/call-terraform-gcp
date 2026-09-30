# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID where the Cloud Storage bucket will be created."
  type        = string
}

variable "region" {
  description = "Default GCP region used by the Google provider."
  type        = string
  default     = "us-central1"
}


# -----------------------------------------------------------------------------
# Cloud Storage Bucket
#
# bucket_name is the globally unique GCS bucket name.
#
# bucket_location controls where the bucket data is stored.
# -----------------------------------------------------------------------------

variable "bucket_name" {
  description = "Globally unique name of the Cloud Storage bucket."
  type        = string
}

variable "bucket_location" {
  description = "Location of the Cloud Storage bucket."
  type        = string
  default     = "US-CENTRAL1"
}

variable "storage_class" {
  description = "Default storage class for objects stored in the bucket."
  type        = string
  default     = "STANDARD"
}


# -----------------------------------------------------------------------------
# Bucket Deletion Behavior
#
# force_destroy = false protects a non-empty bucket from being deleted by
# Terraform.
#
# Destructive behavior must therefore be explicitly enabled by a caller.
# -----------------------------------------------------------------------------

variable "force_destroy" {
  description = "Allow Terraform to delete the bucket when objects are present."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Bucket Access Controls
#
# Uniform bucket-level access uses IAM for bucket/object access control.
#
# Public access prevention defaults to enforced.
# -----------------------------------------------------------------------------

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access."
  type        = bool
  default     = true
}

variable "public_access_prevention" {
  description = "Public access prevention setting for the bucket."
  type        = string
  default     = "enforced"
}


# -----------------------------------------------------------------------------
# Object Versioning
# -----------------------------------------------------------------------------

variable "versioning_enabled" {
  description = "Enable object versioning for the Cloud Storage bucket."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Customer-Managed Encryption Key (CMEK)
#
# kms_key_id follows the platform naming convention established across our
# GCP callers.
#
# The KMS caller exposes:
#
#   crypto_key_id
#
# This Cloud Storage caller consumes:
#
#   kms_key_id
#
# The caller then translates kms_key_id into the provider-oriented
# kms_key_name property expected by the reusable Cloud Storage module.
#
# Leave null to use Google-managed encryption.
# -----------------------------------------------------------------------------

variable "kms_key_id" {
  description = "Optional fully qualified Cloud KMS Crypto Key ID used as the bucket default encryption key."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Resource Labels
# -----------------------------------------------------------------------------

variable "labels" {
  description = "Labels applied to the Cloud Storage bucket."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}


# -----------------------------------------------------------------------------
# Object Lifecycle Rules
#
# Lifecycle rules are optional.
#
# Examples include:
#
# - Moving older objects to another storage class
# - Deleting objects after a certain age
# - Managing older object versions
# -----------------------------------------------------------------------------

variable "lifecycle_rules" {
  description = "Optional lifecycle rules applied to objects in the bucket."

  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })

    condition = object({
      age                   = optional(number)
      created_before        = optional(string)
      with_state            = optional(string)
      matches_storage_class = optional(list(string))
      num_newer_versions    = optional(number)
    })
  }))

  default = []
}


# -----------------------------------------------------------------------------
# Bucket-Level IAM
#
# IAM access is optional.
#
# When iam_members is empty, the caller creates no bucket-level IAM grants.
# -----------------------------------------------------------------------------

variable "iam_role" {
  description = "Bucket-level IAM role assigned to iam_members."
  type        = string
  default     = "roles/storage.objectViewer"
}

variable "iam_members" {
  description = "IAM members granted access to the Cloud Storage bucket."
  type        = set(string)
  default     = []
}
