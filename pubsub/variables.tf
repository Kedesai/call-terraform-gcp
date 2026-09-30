# -----------------------------------------------------------------------------
# GCP Project Configuration
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID where Pub/Sub resources are created."
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
# hcp_organization is optional because this caller can operate without any
# upstream HCP Terraform dependencies.
#
# It becomes required when one of the use_*_workspace options is enabled.
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
# When enabled, the caller retrieves the following output:
#
#   crypto_key_id
#
# from the configured upstream HCP Terraform workspace.
# -----------------------------------------------------------------------------

variable "use_kms_workspace" {
  description = "Use a KMS key retrieved from an HCP Terraform workspace."
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

    error_message = "When use_kms_workspace is true, hcp_organization and kms_workspace_name must be provided."
  }
}

variable "kms_workspace_name" {
  description = "HCP Terraform workspace exposing crypto_key_id."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Optional Publisher Service Account Workspace
#
# When enabled, the caller retrieves:
#
#   service_account_member
#
# Example:
#
#   serviceAccount:publisher@project.iam.gserviceaccount.com
# -----------------------------------------------------------------------------

variable "use_publisher_workspace" {
  description = "Retrieve the publisher IAM member from an HCP Terraform workspace."
  type        = bool
  default     = false

  validation {
    condition = (
      !var.use_publisher_workspace ||
      (
        var.hcp_organization != null &&
        var.publisher_workspace_name != null
      )
    )

    error_message = "When use_publisher_workspace is true, hcp_organization and publisher_workspace_name must be provided."
  }
}

variable "publisher_workspace_name" {
  description = "HCP Terraform workspace exposing the publisher service-account member."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Optional Subscriber Service Account Workspace
#
# When enabled, the caller retrieves:
#
#   service_account_member
# -----------------------------------------------------------------------------

variable "use_subscriber_workspace" {
  description = "Retrieve the subscriber IAM member from an HCP Terraform workspace."
  type        = bool
  default     = false

  validation {
    condition = (
      !var.use_subscriber_workspace ||
      (
        var.hcp_organization != null &&
        var.subscriber_workspace_name != null
      )
    )

    error_message = "When use_subscriber_workspace is true, hcp_organization and subscriber_workspace_name must be provided."
  }
}

variable "subscriber_workspace_name" {
  description = "HCP Terraform workspace exposing the subscriber service-account member."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Additional Publisher and Subscriber IAM Members
#
# These allow identities to be supplied directly rather than through upstream
# HCP Terraform workspaces.
#
# They can also be combined with workspace-derived identities.
# -----------------------------------------------------------------------------

variable "additional_publisher_members" {
  description = "Additional IAM members granted Pub/Sub publisher access."
  type        = set(string)
  default     = []
}

variable "additional_subscriber_members" {
  description = "Additional IAM members granted Pub/Sub subscriber access."
  type        = set(string)
  default     = []
}


# -----------------------------------------------------------------------------
# Primary Pub/Sub Topic
# -----------------------------------------------------------------------------

variable "topic_name" {
  description = "Name of the primary Pub/Sub topic."
  type        = string

  validation {
    condition     = trimspace(var.topic_name) != ""
    error_message = "topic_name must not be empty."
  }
}

variable "topic_labels" {
  description = "Labels applied to the primary Pub/Sub topic."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}

variable "topic_message_retention_duration" {
  description = "Optional topic-level message-retention duration."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Message Storage Policy
#
# Leave allowed_persistence_regions empty to omit the Pub/Sub topic
# message-storage-policy block.
# -----------------------------------------------------------------------------

variable "allowed_persistence_regions" {
  description = "Regions where Pub/Sub can persist topic messages."
  type        = list(string)
  default     = []
}

variable "enforce_in_transit" {
  description = "Enforce the topic message-storage policy while messages are in transit."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Pull Subscription
# -----------------------------------------------------------------------------

variable "subscription_name" {
  description = "Name of the pull subscription."
  type        = string

  validation {
    condition     = trimspace(var.subscription_name) != ""
    error_message = "subscription_name must not be empty."
  }
}

variable "subscription_labels" {
  description = "Labels applied to the Pub/Sub subscription."
  type        = map(string)

  default = {
    managed_by = "terraform"
  }
}

variable "ack_deadline_seconds" {
  description = "Subscriber acknowledgment deadline in seconds."
  type        = number
  default     = 20

  validation {
    condition = (
      var.ack_deadline_seconds >= 10 &&
      var.ack_deadline_seconds <= 600
    )

    error_message = "ack_deadline_seconds must be between 10 and 600."
  }
}

variable "subscription_message_retention_duration" {
  description = "Duration for which subscription messages are retained."
  type        = string
  default     = "604800s"
}

variable "retain_acked_messages" {
  description = "Retain acknowledged messages for the configured retention period."
  type        = bool
  default     = false
}

variable "enable_message_ordering" {
  description = "Enable ordered delivery for messages using ordering keys."
  type        = bool
  default     = false
}

variable "subscription_filter" {
  description = "Optional Pub/Sub subscription filter."
  type        = string
  default     = null
}

variable "expiration_ttl" {
  description = "Optional inactivity duration after which the subscription expires."
  type        = string
  default     = null
}


# -----------------------------------------------------------------------------
# Retry Policy
#
# When enable_retry_policy is false, locals.tf passes null to the reusable
# module and no retry_policy block is generated.
# -----------------------------------------------------------------------------

variable "enable_retry_policy" {
  description = "Enable a retry policy for the subscription."
  type        = bool
  default     = true
}

variable "minimum_backoff" {
  description = "Minimum retry backoff."
  type        = string
  default     = "10s"
}

variable "maximum_backoff" {
  description = "Maximum retry backoff."
  type        = string
  default     = "600s"
}


# -----------------------------------------------------------------------------
# Optional Dead-Letter Topic
#
# When enable_dead_letter_topic is true:
#
# - A second Pub/Sub topic is created.
# - The primary subscription receives a dead-letter policy.
# - dead_letter_topic_name becomes required.
#
# Pub/Sub service-agent IAM required for operational dead-letter forwarding
# remains outside this caller.
# -----------------------------------------------------------------------------

variable "enable_dead_letter_topic" {
  description = "Create and configure a dead-letter topic."
  type        = bool
  default     = false

  validation {
    condition = (
      !var.enable_dead_letter_topic ||
      (
        var.dead_letter_topic_name != null &&
        try(trimspace(var.dead_letter_topic_name) != "", false)
      )
    )

    error_message = "dead_letter_topic_name must be provided when enable_dead_letter_topic is true."
  }
}

variable "dead_letter_topic_name" {
  description = "Name of the optional dead-letter topic."
  type        = string
  default     = null
}

variable "dead_letter_topic_labels" {
  description = "Labels applied to the optional dead-letter topic."
  type        = map(string)

  default = {
    managed_by = "terraform"
    purpose    = "dead-letter"
  }
}

variable "max_delivery_attempts" {
  description = "Approximate delivery attempts before dead-letter forwarding."
  type        = number
  default     = 5

  validation {
    condition = (
      var.max_delivery_attempts >= 5 &&
      var.max_delivery_attempts <= 100
    )

    error_message = "max_delivery_attempts must be between 5 and 100."
  }
}
