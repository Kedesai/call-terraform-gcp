# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID where the KMS resources will be managed."
  type        = string
}

variable "region" {
  description = "Default GCP region used by the Google provider."
  type        = string
  default     = "us-central1"
}

# -----------------------------------------------------------------------------
# KMS Location
#
# KMS resources use their own location setting. Keeping this separate from
# region allows a key ring to use a different or multi-region location later
# without changing the provider configuration.
# -----------------------------------------------------------------------------

variable "kms_location" {
  description = "Location where the KMS Key Ring will be created."
  type        = string
  default     = "us-central1"
}

# -----------------------------------------------------------------------------
# KMS Key Ring
# -----------------------------------------------------------------------------

variable "key_ring_name" {
  description = "Name of the KMS Key Ring."
  type        = string
}

# -----------------------------------------------------------------------------
# KMS Crypto Key
# -----------------------------------------------------------------------------

variable "key_name" {
  description = "Name of the KMS Crypto Key."
  type        = string
}

variable "key_purpose" {
  description = "Purpose of the KMS Crypto Key."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

# -----------------------------------------------------------------------------
# Crypto Key Lifecycle Configuration
#
# rotation_period controls automatic key rotation.
#
# destroy_scheduled_duration controls the delay before a destroyed Crypto Key
# version is permanently removed.
# -----------------------------------------------------------------------------

variable "rotation_period" {
  description = "Rotation period for the KMS Crypto Key."
  type        = string
  default     = "7776000s"
}

variable "destroy_scheduled_duration" {
  description = "Duration before a destroyed key version is permanently destroyed."
  type        = string
  default     = "2592000s"
}

# -----------------------------------------------------------------------------
# Resource Labels
#
# Labels provide metadata that can be used for organization, ownership,
# environment identification, automation, and cost-management conventions.
# -----------------------------------------------------------------------------

variable "labels" {
  description = "Labels applied to the KMS Crypto Key."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}
