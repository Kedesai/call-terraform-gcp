variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Default GCP region."
  type        = string
  default     = "us-central1"
}

variable "create_service_account" {
  description = "Whether to create a new service account."
  type        = bool
  default     = true
}

variable "account_id" {
  description = "Service account ID."
  type        = string
  default     = null
}

variable "display_name" {
  description = "Service account display name."
  type        = string
  default     = null
}

variable "description" {
  description = "Service account description."
  type        = string
  default     = null
}

variable "existing_service_account_email" {
  description = "Existing service account email when create_service_account is false."
  type        = string
  default     = null
}

variable "project_roles" {
  description = "Project-level IAM roles assigned to the service account."
  type        = set(string)
  default     = []
}
