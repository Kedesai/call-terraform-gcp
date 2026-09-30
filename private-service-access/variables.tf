# -----------------------------------------------------------------------------
# GCP Project Configuration
#
# For Shared VPC environments, this must identify the project that owns the VPC
# network and Private Service Access resources.
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project containing the VPC and Private Service Access resources."
  type        = string

  validation {
    condition     = trimspace(var.project_id) != ""
    error_message = "project_id must not be empty."
  }
}


# -----------------------------------------------------------------------------
# HCP Terraform Configuration
#
# The caller retrieves the VPC network ID and network name from an upstream
# HCP Terraform workspace.
# -----------------------------------------------------------------------------

variable "hcp_hostname" {
  description = "HCP Terraform or Terraform Enterprise hostname."
  type        = string
  default     = "app.terraform.io"

  validation {
    condition     = trimspace(var.hcp_hostname) != ""
    error_message = "hcp_hostname must not be empty."
  }
}

variable "hcp_organization" {
  description = "HCP Terraform organization containing the VPC workspace."
  type        = string

  validation {
    condition     = trimspace(var.hcp_organization) != ""
    error_message = "hcp_organization must not be empty."
  }
}

variable "vpc_workspace_name" {
  description = "HCP Terraform workspace exposing network_id and network_name."
  type        = string

  validation {
    condition     = trimspace(var.vpc_workspace_name) != ""
    error_message = "vpc_workspace_name must not be empty."
  }
}


# -----------------------------------------------------------------------------
# Allocated Private Service Access Range
# -----------------------------------------------------------------------------

variable "allocated_range_name" {
  description = "Name of the allocated Private Service Access range."
  type        = string

  validation {
    condition     = trimspace(var.allocated_range_name) != ""
    error_message = "allocated_range_name must not be empty."
  }
}

variable "allocated_range_description" {
  description = "Description of the allocated Private Service Access range."
  type        = string
  default     = "Private Service Access range managed by Terraform."
}

variable "address" {
  description = "Optional starting IPv4 address for the allocated range."
  type        = string
  default     = null

  validation {
    condition = (
      var.address == null ||
      can(cidrhost("${var.address}/32", 0))
    )

    error_message = "address must be a valid IPv4 address."
  }
}

variable "prefix_length" {
  description = "Prefix length of the allocated Private Service Access range."
  type        = number
  default     = 16

  validation {
    condition = (
      var.prefix_length >= 16 &&
      var.prefix_length <= 24
    )

    error_message = "prefix_length must be between 16 and 24."
  }
}


# -----------------------------------------------------------------------------
# Service Networking Connection
# -----------------------------------------------------------------------------

variable "service" {
  description = "Service producer used by the Private Service Access connection."
  type        = string
  default     = "servicenetworking.googleapis.com"

  validation {
    condition     = trimspace(var.service) != ""
    error_message = "service must not be empty."
  }
}


# -----------------------------------------------------------------------------
# Connection Lifecycle
#
# REMOVE_PEERING is an escape hatch intended only for controlled teardown after
# all dependent producer-service resources have been removed.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Connection Lifecycle
#
# PREVENT:
#   Prevents Terraform from deleting the Service Networking connection.
#
# ABANDON:
#   Removes the resource from Terraform management without deleting the
#   connection through the API.
#
# DELETE:
#   Allows Terraform to request deletion of the connection.
# -----------------------------------------------------------------------------

variable "deletion_policy" {
  description = "Deletion policy for the Service Networking connection."
  type        = string
  default     = "PREVENT"

  validation {
    condition = contains(
      [
        "PREVENT",
        "ABANDON",
        "DELETE"
      ],
      upper(var.deletion_policy)
    )

    error_message = "deletion_policy must be PREVENT, ABANDON, or DELETE."
  }
}

variable "update_on_creation_fail" {
  description = "Attempt to update reserved ranges when connection creation fails because a connection already exists."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Optional Custom Route Exchange
# -----------------------------------------------------------------------------

variable "import_custom_routes" {
  description = "Import custom routes from the service producer peering."
  type        = bool
  default     = false
}

variable "export_custom_routes" {
  description = "Export custom routes to the service producer peering."
  type        = bool
  default     = false
}
