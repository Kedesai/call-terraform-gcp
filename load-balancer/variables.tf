# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project containing the load balancer."
  type        = string

  validation {
    condition     = trimspace(var.project_id) != ""
    error_message = "project_id must not be empty."
  }
}


# -----------------------------------------------------------------------------
# HCP Terraform Configuration
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
  description = "HCP Terraform organization containing the MIG workspace."
  type        = string

  validation {
    condition     = trimspace(var.hcp_organization) != ""
    error_message = "hcp_organization must not be empty."
  }
}

variable "mig_workspace_name" {
  description = "HCP Terraform workspace exposing the MIG instance_group output."
  type        = string

  validation {
    condition     = trimspace(var.mig_workspace_name) != ""
    error_message = "mig_workspace_name must not be empty."
  }
}


# -----------------------------------------------------------------------------
# Load Balancer Identity
# -----------------------------------------------------------------------------

variable "name" {
  description = "Base name used for the load-balancer resources."
  type        = string

  validation {
    condition     = trimspace(var.name) != ""
    error_message = "name must not be empty."
  }
}


# -----------------------------------------------------------------------------
# Backend Configuration
# -----------------------------------------------------------------------------

variable "backend_protocol" {
  description = "Protocol used between the load balancer and backend."
  type        = string
  default     = "HTTP"

  validation {
    condition = contains(
      [
        "HTTP",
        "HTTPS",
        "HTTP2"
      ],
      upper(var.backend_protocol)
    )

    error_message = "backend_protocol must be HTTP, HTTPS, or HTTP2."
  }
}

variable "port_name" {
  description = "MIG named port used by the backend service."
  type        = string
  default     = "http"

  validation {
    condition     = trimspace(var.port_name) != ""
    error_message = "port_name must not be empty."
  }
}

variable "timeout_sec" {
  description = "Backend timeout in seconds."
  type        = number
  default     = 30

  validation {
    condition     = var.timeout_sec > 0
    error_message = "timeout_sec must be greater than zero."
  }
}

variable "enable_cdn" {
  description = "Enable Cloud CDN."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Backend Balancing
# -----------------------------------------------------------------------------

variable "balancing_mode" {
  description = "Backend balancing mode. The initial module supports UTILIZATION."
  type        = string
  default     = "UTILIZATION"

  validation {
    condition = (
      upper(var.balancing_mode) == "UTILIZATION"
    )

    error_message = "balancing_mode must be UTILIZATION."
  }
}

variable "capacity_scaler" {
  description = "Fraction of backend capacity available to the load balancer."
  type        = number
  default     = 1.0

  validation {
    condition = (
      var.capacity_scaler >= 0 &&
      var.capacity_scaler <= 1
    )

    error_message = "capacity_scaler must be between 0 and 1."
  }
}

variable "max_utilization" {
  description = "Maximum backend utilization."
  type        = number
  default     = 0.8

  validation {
    condition = (
      var.max_utilization > 0 &&
      var.max_utilization <= 1
    )

    error_message = "max_utilization must be greater than zero and no greater than one."
  }
}


# -----------------------------------------------------------------------------
# HTTP Health Check
# -----------------------------------------------------------------------------

variable "health_check_port" {
  description = "Backend health-check port."
  type        = number
  default     = 8080

  validation {
    condition = (
      var.health_check_port >= 1 &&
      var.health_check_port <= 65535
    )

    error_message = "health_check_port must be between 1 and 65535."
  }
}

variable "health_check_request_path" {
  description = "Backend HTTP health-check path."
  type        = string
  default     = "/"

  validation {
    condition = (
      startswith(var.health_check_request_path, "/")
    )

    error_message = "health_check_request_path must start with '/'."
  }
}

variable "health_check_interval_sec" {
  description = "Health-check interval in seconds."
  type        = number
  default     = 10

  validation {
    condition     = var.health_check_interval_sec > 0
    error_message = "health_check_interval_sec must be greater than zero."
  }
}

variable "health_check_timeout_sec" {
  description = "Health-check timeout in seconds."
  type        = number
  default     = 5

  validation {
    condition     = var.health_check_timeout_sec > 0
    error_message = "health_check_timeout_sec must be greater than zero."
  }
}

variable "healthy_threshold" {
  description = "Successful health checks required for healthy status."
  type        = number
  default     = 2

  validation {
    condition     = var.healthy_threshold > 0
    error_message = "healthy_threshold must be greater than zero."
  }
}

variable "unhealthy_threshold" {
  description = "Failed health checks required for unhealthy status."
  type        = number
  default     = 3

  validation {
    condition     = var.unhealthy_threshold > 0
    error_message = "unhealthy_threshold must be greater than zero."
  }
}


# -----------------------------------------------------------------------------
# Logging
# -----------------------------------------------------------------------------

variable "enable_logging" {
  description = "Enable backend request logging."
  type        = bool
  default     = true
}

variable "log_sample_rate" {
  description = "Load-balancer logging sample rate."
  type        = number
  default     = 1.0

  validation {
    condition = (
      var.log_sample_rate >= 0 &&
      var.log_sample_rate <= 1
    )

    error_message = "log_sample_rate must be between 0 and 1."
  }
}
