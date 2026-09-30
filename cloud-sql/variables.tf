# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project containing the Cloud SQL instance."
  type        = string

  validation {
    condition     = trimspace(var.project_id) != ""
    error_message = "project_id must not be empty."
  }
}

variable "region" {
  description = "GCP region containing the Cloud SQL instance."
  type        = string
  default     = "us-central1"

  validation {
    condition     = trimspace(var.region) != ""
    error_message = "region must not be empty."
  }
}


# -----------------------------------------------------------------------------
# HCP Terraform Configuration
# -----------------------------------------------------------------------------

variable "hcp_hostname" {
  description = "HCP Terraform or Terraform Enterprise hostname."
  type        = string
  default     = "app.terraform.io"
}

variable "hcp_organization" {
  description = "HCP Terraform organization containing upstream workspaces."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Optional KMS Workspace
#
# The upstream workspace must expose:
#
#   crypto_key_id
# -----------------------------------------------------------------------------

variable "use_kms_workspace" {
  description = "Retrieve the Cloud SQL CMEK key from an HCP Terraform workspace."
  type        = bool
  default     = false

  validation {
    condition = (
      !var.use_kms_workspace ||
      (
        var.hcp_organization != null &&
        var.kms_workspace_name != null
      )
    )

    error_message = "hcp_organization and kms_workspace_name must be provided when use_kms_workspace is true."
  }
}

variable "kms_workspace_name" {
  description = "HCP Terraform workspace exposing crypto_key_id."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Cloud SQL Instance
# -----------------------------------------------------------------------------

variable "instance_name" {
  description = "Cloud SQL instance name."
  type        = string

  validation {
    condition     = trimspace(var.instance_name) != ""
    error_message = "instance_name must not be empty."
  }
}

variable "database_version" {
  description = "Cloud SQL database engine/version."
  type        = string
  default     = "POSTGRES_15"

  validation {
    condition = (
      startswith(upper(var.database_version), "POSTGRES_") ||
      startswith(upper(var.database_version), "MYSQL_") ||
      startswith(upper(var.database_version), "SQLSERVER_")
    )

    error_message = "database_version must identify a PostgreSQL, MySQL, or SQL Server Cloud SQL engine."
  }
}

variable "tier" {
  description = "Cloud SQL machine tier."
  type        = string
  default     = "db-custom-2-7680"

  validation {
    condition     = trimspace(var.tier) != ""
    error_message = "tier must not be empty."
  }
}

variable "availability_type" {
  description = "Cloud SQL availability type."
  type        = string
  default     = "ZONAL"

  validation {
    condition = contains(
      ["ZONAL", "REGIONAL"],
      upper(var.availability_type)
    )

    error_message = "availability_type must be ZONAL or REGIONAL."
  }
}

variable "edition" {
  description = "Optional Cloud SQL edition."
  type        = string
  default     = null

  validation {
    condition = (
      var.edition == null ||
      contains(
        ["ENTERPRISE", "ENTERPRISE_PLUS"],
        upper(var.edition)
      )
    )

    error_message = "edition must be ENTERPRISE, ENTERPRISE_PLUS, or null."
  }
}


# -----------------------------------------------------------------------------
# Private Networking
#
# Private Service Access and Service Networking must already exist.
# -----------------------------------------------------------------------------

variable "private_network" {
  description = "Existing VPC network self-link used by the Cloud SQL instance."
  type        = string

  validation {
    condition     = trimspace(var.private_network) != ""
    error_message = "private_network must not be empty."
  }
}

variable "allocated_ip_range" {
  description = "Optional allocated Private Service Access range name."
  type        = string
  default     = null
}

variable "enable_private_path_for_google_cloud_services" {
  description = "Allow supported Google Cloud services to access Cloud SQL through private IP."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Public Connectivity
#
# The caller is private-first. Public IPv4 is disabled by default.
# -----------------------------------------------------------------------------

variable "ipv4_enabled" {
  description = "Enable a public IPv4 address."
  type        = bool
  default     = false
}

variable "ssl_mode" {
  description = "Optional SSL mode used for Cloud SQL client connections."
  type        = string
  default     = "ENCRYPTED_ONLY"

  validation {
    condition = (
      var.ssl_mode == null ||
      contains(
        [
          "ALLOW_UNENCRYPTED_AND_ENCRYPTED",
          "ENCRYPTED_ONLY",
          "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
        ],
        upper(var.ssl_mode)
      )
    )

    error_message = "ssl_mode must be ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, TRUSTED_CLIENT_CERTIFICATE_REQUIRED, or null."
  }

  validation {
    condition = !(
      try(
        upper(var.ssl_mode) == "TRUSTED_CLIENT_CERTIFICATE_REQUIRED",
        false
      ) &&
      startswith(
        upper(var.database_version),
        "SQLSERVER_"
      )
    )

    error_message = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED is not supported for SQL Server."
  }
}

variable "authorized_networks" {
  description = "Networks authorized to reach the Cloud SQL public IP."

  type = list(object({
    name            = string
    value           = string
    expiration_time = optional(string)
  }))

  default = []

  validation {
    condition = (
      length(var.authorized_networks) == 0 ||
      var.ipv4_enabled
    )

    error_message = "authorized_networks can only be configured when ipv4_enabled is true."
  }
}


# -----------------------------------------------------------------------------
# Storage
# -----------------------------------------------------------------------------

variable "disk_type" {
  description = "Cloud SQL persistent disk type."
  type        = string
  default     = "PD_SSD"

  validation {
    condition = contains(
      ["PD_SSD", "PD_HDD"],
      upper(var.disk_type)
    )

    error_message = "disk_type must be PD_SSD or PD_HDD."
  }
}

variable "disk_size_gb" {
  description = "Initial Cloud SQL disk size in GB."
  type        = number
  default     = 20

  validation {
    condition     = var.disk_size_gb > 0
    error_message = "disk_size_gb must be greater than zero."
  }
}

variable "disk_autoresize" {
  description = "Allow Cloud SQL storage to grow automatically."
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "Maximum automatic disk size in GB. Zero leaves the service default behavior."
  type        = number
  default     = 0

  validation {
    condition     = var.disk_autoresize_limit >= 0
    error_message = "disk_autoresize_limit cannot be negative."
  }

  validation {
    condition = (
      var.disk_autoresize_limit == 0 ||
      var.disk_autoresize_limit >= var.disk_size_gb
    )

    error_message = "disk_autoresize_limit must be zero or greater than or equal to disk_size_gb."
  }
}


# -----------------------------------------------------------------------------
# Automated Backups
# -----------------------------------------------------------------------------

variable "backup_enabled" {
  description = "Enable automated Cloud SQL backups."
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Automated backup start time in HH:MM format."
  type        = string
  default     = "03:00"

  validation {
    condition = can(
      regex(
        "^([01][0-9]|2[0-3]):[0-5][0-9]$",
        var.backup_start_time
      )
    )

    error_message = "backup_start_time must use HH:MM format, for example 03:00."
  }
}

variable "backup_location" {
  description = "Optional automated backup location."
  type        = string
  default     = null
}

variable "retained_backups" {
  description = "Number of automated backups retained."
  type        = number
  default     = 7

  validation {
    condition     = var.retained_backups > 0
    error_message = "retained_backups must be greater than zero."
  }
}


# -----------------------------------------------------------------------------
# MySQL Binary Logging
# -----------------------------------------------------------------------------

variable "binary_log_enabled" {
  description = "Enable binary logging for MySQL Cloud SQL instances."
  type        = bool
  default     = true
}


# -----------------------------------------------------------------------------
# PostgreSQL and SQL Server Point-in-Time Recovery
# -----------------------------------------------------------------------------

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery for supported engines."
  type        = bool
  default     = true
}

variable "transaction_log_retention_days" {
  description = "Transaction-log retention period for supported engines."
  type        = number
  default     = 7

  validation {
    condition = (
      var.transaction_log_retention_days >= 1 &&
      var.transaction_log_retention_days <= 7
    )

    error_message = "transaction_log_retention_days must be between 1 and 7."
  }
}


# -----------------------------------------------------------------------------
# Maintenance Window
# -----------------------------------------------------------------------------

variable "maintenance_window_day" {
  description = "Optional maintenance-window day from 1 through 7."
  type        = number
  default     = null

  validation {
    condition = (
      var.maintenance_window_day == null ||
      (
        var.maintenance_window_day >= 1 &&
        var.maintenance_window_day <= 7
      )
    )

    error_message = "maintenance_window_day must be between 1 and 7."
  }
}

variable "maintenance_window_hour" {
  description = "Optional maintenance-window hour from 0 through 23."
  type        = number
  default     = null

  validation {
    condition = (
      var.maintenance_window_hour == null ||
      (
        var.maintenance_window_hour >= 0 &&
        var.maintenance_window_hour <= 23
      )
    )

    error_message = "maintenance_window_hour must be between 0 and 23."
  }
}

variable "maintenance_update_track" {
  description = "Cloud SQL maintenance update track."
  type        = string
  default     = "stable"

  validation {
    condition = contains(
      ["stable", "canary"],
      lower(var.maintenance_update_track)
    )

    error_message = "maintenance_update_track must be stable or canary."
  }
}


# -----------------------------------------------------------------------------
# Database Flags
# -----------------------------------------------------------------------------

variable "database_flags" {
  description = "Database flags applied to the Cloud SQL instance."
  type        = map(string)
  default     = {}
}


# -----------------------------------------------------------------------------
# Labels and Protection
# -----------------------------------------------------------------------------

variable "user_labels" {
  description = "Labels applied to the Cloud SQL instance."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}

variable "deletion_protection" {
  description = "Protect the Cloud SQL instance against Terraform deletion."
  type        = bool
  default     = true
}


# -----------------------------------------------------------------------------
# Databases
# -----------------------------------------------------------------------------

variable "databases" {
  description = "Databases created inside the Cloud SQL instance."

  type = map(object({
    name            = string
    charset         = optional(string)
    collation       = optional(string)
    deletion_policy = optional(string, "DELETE")
  }))

  default = {}

  validation {
    condition = alltrue([
      for database in values(var.databases) :
      trimspace(database.name) != ""
    ])

    error_message = "Each Cloud SQL database must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for database in values(var.databases) :
      contains(
        ["DELETE", "ABANDON"],
        upper(database.deletion_policy)
      )
    ])

    error_message = "Each database deletion_policy must be DELETE or ABANDON."
  }
}
