# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID where the GKE cluster is created."
  type        = string
}

variable "region" {
  description = "Default GCP region used by the Google provider."
  type        = string
  default     = "us-central1"
}


# -----------------------------------------------------------------------------
# HCP Terraform Configuration
#
# These values identify the HCP Terraform organization and the upstream
# workspaces whose outputs are consumed by this GKE caller.
# -----------------------------------------------------------------------------

variable "hcp_hostname" {
  description = "Hostname of the HCP Terraform or Terraform Enterprise instance."
  type        = string
  default     = "app.terraform.io"
}

variable "hcp_organization" {
  description = "HCP Terraform organization containing the dependent workspaces."
  type        = string
}

variable "network_workspace_name" {
  description = "HCP Terraform workspace containing the VPC and subnet outputs."
  type        = string
}

variable "network_subnet_key" {
  description = "Logical subnet key used in the VPC workspace subnet output map."
  type        = string
  default     = "gke"
}


# -----------------------------------------------------------------------------
# Optional Service Account Workspace
#
# When use_service_account_workspace is true, the caller reads the node service
# account email from the specified HCP Terraform workspace.
#
# When false, no service-account workspace output is consumed.
# -----------------------------------------------------------------------------

variable "use_service_account_workspace" {
  description = "Read the GKE node service account from an HCP Terraform workspace."
  type        = bool
  default     = false
}

variable "service_account_workspace_name" {
  description = "HCP Terraform workspace containing the node service account output."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Optional KMS Workspace
#
# When use_kms_workspace is true, the caller retrieves crypto_key_id from the
# specified KMS workspace and uses it for GKE database encryption.
#
# When false, no GKE database-encryption key is configured by this caller.
# -----------------------------------------------------------------------------

variable "use_kms_workspace" {
  description = "Read the GKE database-encryption key from an HCP Terraform workspace."
  type        = bool
  default     = false
}

variable "kms_workspace_name" {
  description = "HCP Terraform workspace containing the KMS Crypto Key output."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# GKE Cluster Configuration
# -----------------------------------------------------------------------------

variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "cluster_location" {
  description = "Region or zone where the GKE cluster is created."
  type        = string
  default     = "us-central1"
}

variable "cluster_description" {
  description = "Optional description of the GKE cluster."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Enable deletion protection for the GKE cluster."
  type        = bool
  default     = true
}

variable "resource_labels" {
  description = "Labels applied to the GKE cluster."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}


# -----------------------------------------------------------------------------
# VPC-Native Secondary Range Names
#
# The VPC workspace creates the secondary ranges, while this GKE caller tells
# GKE which named ranges to use.
#
# These defaults must match the range names used by the VPC caller.
# -----------------------------------------------------------------------------

variable "cluster_secondary_range_name" {
  description = "Subnet secondary range name used for GKE Pods."
  type        = string
  default     = "gke-pods"
}

variable "services_secondary_range_name" {
  description = "Subnet secondary range name used for Kubernetes Services."
  type        = string
  default     = "gke-services"
}


# -----------------------------------------------------------------------------
# Private Cluster Configuration
# -----------------------------------------------------------------------------

variable "enable_private_nodes" {
  description = "Create GKE nodes with private IP addresses only."
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Expose only the private GKE control-plane endpoint."
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR range used by the private GKE control plane."
  type        = string
  default     = "172.16.0.0/28"
}

variable "master_global_access_enabled" {
  description = "Allow private control-plane access from any Google Cloud region."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Control-Plane Authorized Networks
#
# Use this when the control-plane endpoint is reachable through a public
# endpoint and access needs to be restricted to selected CIDR ranges.
# -----------------------------------------------------------------------------

variable "master_authorized_networks" {
  description = "CIDR blocks authorized to access the GKE control plane."

  type = list(object({
    cidr_block   = string
    display_name = optional(string)
  }))

  default = []
}


# -----------------------------------------------------------------------------
# Release and Security Configuration
# -----------------------------------------------------------------------------

variable "release_channel" {
  description = "GKE release channel."
  type        = string
  default     = "REGULAR"

  validation {
    condition = contains(
      ["RAPID", "REGULAR", "STABLE", "EXTENDED", "UNSPECIFIED"],
      upper(var.release_channel)
    )

    error_message = "release_channel must be RAPID, REGULAR, STABLE, EXTENDED, or UNSPECIFIED."
  }
}

variable "enable_workload_identity" {
  description = "Enable Workload Identity Federation for GKE."
  type        = bool
  default     = true
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded GKE nodes."
  type        = bool
  default     = true
}

variable "enable_network_policy" {
  description = "Enable GKE network policy."
  type        = bool
  default     = true
}

variable "enable_intranode_visibility" {
  description = "Enable visibility for traffic between Pods on the same node."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Logging and Monitoring
# -----------------------------------------------------------------------------

variable "logging_service" {
  description = "Logging service used by the GKE cluster."
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "Monitoring service used by the GKE cluster."
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}


# -----------------------------------------------------------------------------
# System Node Pool
#
# This caller creates one logical node pool named "system".
#
# The reusable module remains capable of managing multiple node pools.
# -----------------------------------------------------------------------------

variable "node_pool_name" {
  description = "Name of the GKE system node pool."
  type        = string
  default     = "system"
}

variable "node_locations" {
  description = "Optional zones used by the node pool."
  type        = list(string)
  default     = null
}

variable "initial_node_count" {
  description = "Initial number of nodes per zone."
  type        = number
  default     = 1

  validation {
    condition     = var.initial_node_count > 0
    error_message = "initial_node_count must be greater than zero."
  }
}

variable "enable_node_autoscaling" {
  description = "Enable autoscaling for the system node pool."
  type        = bool
  default     = true
}

variable "node_min_count" {
  description = "Minimum number of nodes per zone."
  type        = number
  default     = 1
}

variable "node_max_count" {
  description = "Maximum number of nodes per zone."
  type        = number
  default     = 3

  validation {
    condition     = var.node_max_count >= var.node_min_count
    error_message = "node_max_count must be greater than or equal to node_min_count."
  }
}

variable "node_machine_type" {
  description = "Compute Engine machine type used by the GKE node pool."
  type        = string
  default     = "e2-standard-4"
}

variable "node_disk_size_gb" {
  description = "Boot disk size for each GKE node."
  type        = number
  default     = 100

  validation {
    condition     = var.node_disk_size_gb > 0
    error_message = "node_disk_size_gb must be greater than zero."
  }
}

variable "node_disk_type" {
  description = "Persistent disk type used by GKE nodes."
  type        = string
  default     = "pd-balanced"
}

variable "node_image_type" {
  description = "Operating-system image used by GKE nodes."
  type        = string
  default     = "COS_CONTAINERD"
}

variable "node_auto_repair" {
  description = "Enable automatic repair for the node pool."
  type        = bool
  default     = true
}

variable "node_auto_upgrade" {
  description = "Enable automatic upgrade for the node pool."
  type        = bool
  default     = true
}

variable "node_max_surge" {
  description = "Maximum additional nodes created during an upgrade."
  type        = number
  default     = 1
}

variable "node_max_unavailable" {
  description = "Maximum nodes unavailable during an upgrade."
  type        = number
  default     = 0
}

variable "node_labels" {
  description = "Labels applied to GKE nodes."
  type        = map(string)

  default = {
    managed_by = "terraform"
    node_pool  = "system"
  }
}

variable "node_metadata" {
  description = "Metadata applied to GKE nodes."
  type        = map(string)

  default = {
    disable-legacy-endpoints = "true"
  }
}

variable "node_network_tags" {
  description = "Network tags applied to GKE nodes."
  type        = set(string)
  default     = []
}

variable "node_oauth_scopes" {
  description = "OAuth scopes assigned to the node service account."
  type        = set(string)

  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "node_enable_secure_boot" {
  description = "Enable Secure Boot for GKE nodes."
  type        = bool
  default     = false
}

variable "node_enable_integrity_monitoring" {
  description = "Enable integrity monitoring for GKE nodes."
  type        = bool
  default     = true
}

variable "node_spot" {
  description = "Use Spot VMs for the node pool."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Maintenance Window
#
# All three values must be supplied to create a recurring maintenance window.
# -----------------------------------------------------------------------------

variable "maintenance_start_time" {
  description = "Optional RFC 3339 maintenance-window start time."
  type        = string
  default     = null
}

variable "maintenance_end_time" {
  description = "Optional RFC 3339 maintenance-window end time."
  type        = string
  default     = null
}

variable "maintenance_recurrence" {
  description = "Optional RFC 5545 maintenance recurrence rule."
  type        = string
  default     = null
}
