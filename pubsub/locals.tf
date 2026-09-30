# -----------------------------------------------------------------------------
# Caller Composition Logic
#
# Translates the simplified Pub/Sub caller interface into the map-based
# structures expected by the reusable Pub/Sub module.
# -----------------------------------------------------------------------------

locals {

  # ---------------------------------------------------------------------------
  # Optional KMS Key
  # ---------------------------------------------------------------------------

  kms_key_id = var.use_kms_workspace ? (
    data.tfe_outputs.kms[0]
    .nonsensitive_values
    .crypto_key_id
  ) : null


  # ---------------------------------------------------------------------------
  # Publisher IAM Members
  # ---------------------------------------------------------------------------

  publisher_workspace_members = var.use_publisher_workspace ? toset([
    data.tfe_outputs.publisher[0]
    .nonsensitive_values
    .service_account_member
  ]) : toset([])

  publisher_members = setunion(
    local.publisher_workspace_members,
    var.additional_publisher_members
  )


  # ---------------------------------------------------------------------------
  # Subscriber IAM Members
  # ---------------------------------------------------------------------------

  subscriber_workspace_members = var.use_subscriber_workspace ? toset([
    data.tfe_outputs.subscriber[0]
    .nonsensitive_values
    .service_account_member
  ]) : toset([])

  subscriber_members = setunion(
    local.subscriber_workspace_members,
    var.additional_subscriber_members
  )


  # ---------------------------------------------------------------------------
  # Primary Topic
  # ---------------------------------------------------------------------------

  primary_topic = {
    primary = {
      name                       = var.topic_name
      labels                     = var.topic_labels
      message_retention_duration = var.topic_message_retention_duration
      kms_key_name               = local.kms_key_id

      allowed_persistence_regions = (
        var.allowed_persistence_regions
      )

      enforce_in_transit = var.enforce_in_transit
    }
  }


  # ---------------------------------------------------------------------------
  # Optional Dead-Letter Topic
  #
  # Keep the object shape identical to the primary-topic object.
  # ---------------------------------------------------------------------------

  dead_letter_topic = var.enable_dead_letter_topic ? {
    dead_letter = {
      name                        = var.dead_letter_topic_name
      labels                      = var.dead_letter_topic_labels
      message_retention_duration  = null
      kms_key_name                = local.kms_key_id
      allowed_persistence_regions = []
      enforce_in_transit          = false
    }
  } : {}


  # ---------------------------------------------------------------------------
  # Complete Topic Map
  # ---------------------------------------------------------------------------

  topics = merge(
    local.primary_topic,
    local.dead_letter_topic
  )


  # ---------------------------------------------------------------------------
  # Primary Pull Subscription
  # ---------------------------------------------------------------------------

  subscriptions = {
    primary = {
      name  = var.subscription_name
      topic = "primary"

      labels = var.subscription_labels

      ack_deadline_seconds = var.ack_deadline_seconds

      message_retention_duration = (
        var.subscription_message_retention_duration
      )

      retain_acked_messages   = var.retain_acked_messages
      enable_message_ordering = var.enable_message_ordering

      filter         = var.subscription_filter
      expiration_ttl = var.expiration_ttl

      retry_policy = var.enable_retry_policy ? {
        minimum_backoff = var.minimum_backoff
        maximum_backoff = var.maximum_backoff
      } : null

      dead_letter_policy = var.enable_dead_letter_topic ? {
        dead_letter_topic     = "dead_letter"
        max_delivery_attempts = var.max_delivery_attempts
      } : null
    }
  }


  # ---------------------------------------------------------------------------
  # Publisher IAM
  # ---------------------------------------------------------------------------

  topic_iam_bindings = length(local.publisher_members) > 0 ? {
    primary_publishers = {
      topic   = "primary"
      role    = "roles/pubsub.publisher"
      members = local.publisher_members
    }
  } : {}


  # ---------------------------------------------------------------------------
  # Subscriber IAM
  # ---------------------------------------------------------------------------

  subscription_iam_bindings = length(local.subscriber_members) > 0 ? {
    primary_subscribers = {
      subscription = "primary"
      role         = "roles/pubsub.subscriber"
      members      = local.subscriber_members
    }
  } : {}
}
