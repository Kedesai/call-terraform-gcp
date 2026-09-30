# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID where the VM will be created."
  type        = string
}

variable "region" {
  description = "Default GCP region used by the Google provider."
  type        = string
  default     = "us-central1"
}

# -----------------------------------------------------------------------------
# VM Configuration
# -----------------------------------------------------------------------------

variable "instance_name" {
  description = "Name of the Compute Engine VM instance."
  type        = string
}

variable "zone" {
  description = "GCP zone where the VM will be created."
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Compute Engine machine type."
  type        = string
  default     = "e2-medium"
}

variable "description" {
  description = "Optional description of the VM."
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# VM Protection and Update Behavior
#
# deletion_protection protects the instance against accidental deletion.
#
# allow_stopping_for_update permits Terraform to stop the VM when a requested
# configuration update cannot be performed while the VM is running.
# -----------------------------------------------------------------------------

variable "deletion_protection" {
  description = "Enable deletion protection for the VM."
  type        = bool
  default     = true
}

variable "allow_stopping_for_update" {
  description = "Allow Terraform to stop the VM when required for an update."
  type        = bool
  default     = true
}

variable "can_ip_forward" {
  description = "Allow the VM to forward IP packets."
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Boot Disk Configuration
# -----------------------------------------------------------------------------

variable "boot_disk_image" {
  description = "Compute Engine image used for the VM boot disk."
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size_gb" {
  description = "Size of the VM boot disk in GB."
  type        = number
  default     = 20

  validation {
    condition     = var.boot_disk_size_gb > 0
    error_message = "boot_disk_size_gb must be greater than zero."
  }
}

variable "boot_disk_type" {
  description = "Persistent disk type used for the VM boot disk."
  type        = string
  default     = "pd-balanced"
}

variable "boot_disk_auto_delete" {
  description = "Delete the boot disk when the VM is deleted."
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Customer-Managed Encryption Key
#
# This follows the common caller interface used across our GCP modules:
#
# KMS caller output:
#   crypto_key_id
#
# VM caller input:
#   kms_key_id
# -----------------------------------------------------------------------------

variable "kms_key_id" {
  description = "Optional fully qualified Cloud KMS Crypto Key ID for boot disk encryption."
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Networking
#
# subnetwork_self_link should normally be supplied from the VPC caller output.
#
# The VM remains private unless assign_external_ip is explicitly enabled.
# -----------------------------------------------------------------------------

variable "subnetwork_self_link" {
  description = "Self-link of the subnet where the VM network interface is created."
  type        = string
}

variable "private_ip_address" {
  description = "Optional static internal IP address for the VM."
  type        = string
  default     = null
}

variable "assign_external_ip" {
  description = "Assign an external IPv4 address to the VM."
  type        = bool
  default     = false
}

variable "network_tier" {
  description = "Network tier used when an external IP address is assigned."
  type        = string
  default     = "PREMIUM"

  validation {
    condition = contains(
      ["PREMIUM", "STANDARD"],
      upper(var.network_tier)
    )

    error_message = "network_tier must be PREMIUM or STANDARD."
  }
}

# -----------------------------------------------------------------------------
# Service Account
#
# service_account_email should normally consume the email output from the
# service-account caller.
#
# Leave null when no custom service account should be attached.
# -----------------------------------------------------------------------------

variable "service_account_email" {
  description = "Optional service account email attached to the VM."
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "OAuth scopes assigned to the VM service account."
  type        = set(string)

  default = [
    "cloud-platform"
  ]
}

# -----------------------------------------------------------------------------
# Instance Metadata
#
# Sensitive values must not be placed in metadata or startup scripts.
# -----------------------------------------------------------------------------

variable "metadata" {
  description = "Metadata assigned to the VM."
  type        = map(string)
  default     = {}
}

variable "startup_script" {
  description = "Optional startup script executed by the VM."
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Network Tags and Labels
# -----------------------------------------------------------------------------

variable "network_tags" {
  description = "Network tags applied to the VM."
  type        = set(string)
  default     = []
}

variable "labels" {
  description = "Labels applied to the VM."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}

# -----------------------------------------------------------------------------
# VM Scheduling
#
# STANDARD instances normally use automatic restart and MIGRATE.
#
# SPOT instances should use automatic_restart = false and
# on_host_maintenance = TERMINATE.
# -----------------------------------------------------------------------------

variable "automatic_restart" {
  description = "Automatically restart the VM following infrastructure failure."
  type        = bool
  default     = true
}

variable "on_host_maintenance" {
  description = "VM behavior during host maintenance."
  type        = string
  default     = "MIGRATE"

  validation {
    condition = contains(
      ["MIGRATE", "TERMINATE"],
      upper(var.on_host_maintenance)
    )

    error_message = "on_host_maintenance must be MIGRATE or TERMINATE."
  }
}

variable "provisioning_model" {
  description = "VM provisioning model."
  type        = string
  default     = "STANDARD"

  validation {
    condition = contains(
      ["STANDARD", "SPOT"],
      upper(var.provisioning_model)
    )

    error_message = "provisioning_model must be STANDARD or SPOT."
  }

  validation {
    condition = (
      upper(var.provisioning_model) != "SPOT" ||
      (
        var.automatic_restart == false &&
        upper(var.on_host_maintenance) == "TERMINATE"
      )
    )

    error_message = "SPOT instances require automatic_restart = false and on_host_maintenance = TERMINATE."
  }
}

variable "preemptible" {
  description = "Whether the VM uses the legacy preemptible configuration."
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Shielded VM Configuration
# -----------------------------------------------------------------------------

variable "enable_secure_boot" {
  description = "Enable Shielded VM Secure Boot."
  type        = bool
  default     = false
}

variable "enable_vtpm" {
  description = "Enable Shielded VM virtual TPM."
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Enable Shielded VM integrity monitoring."
  type        = bool
  default     = true
}
