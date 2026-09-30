# -----------------------------------------------------------------------------
# Primary Topic Outputs
# -----------------------------------------------------------------------------

output "topic_id" {
  description = "Primary Pub/Sub topic resource ID."
  value       = module.pubsub.topic_ids["primary"]
}

output "topic_name" {
  description = "Primary Pub/Sub topic name."
  value       = module.pubsub.topic_names["primary"]
}


# -----------------------------------------------------------------------------
# Primary Subscription Outputs
# -----------------------------------------------------------------------------

output "subscription_id" {
  description = "Primary Pub/Sub subscription resource ID."
  value       = module.pubsub.subscription_ids["primary"]
}

output "subscription_name" {
  description = "Primary Pub/Sub subscription name."
  value       = module.pubsub.subscription_names["primary"]
}

output "subscription_topic" {
  description = "Topic resource ID associated with the primary subscription."
  value       = module.pubsub.subscription_topics["primary"]
}


# -----------------------------------------------------------------------------
# Optional Dead-Letter Topic Outputs
# -----------------------------------------------------------------------------

output "dead_letter_topic_id" {
  description = "Dead-letter topic resource ID, or null when disabled."

  value = var.enable_dead_letter_topic ? (
    module.pubsub.topic_ids["dead_letter"]
  ) : null
}

output "dead_letter_topic_name" {
  description = "Dead-letter topic name, or null when disabled."

  value = var.enable_dead_letter_topic ? (
    module.pubsub.topic_names["dead_letter"]
  ) : null
}


# -----------------------------------------------------------------------------
# IAM Outputs
# -----------------------------------------------------------------------------

output "topic_iam_members" {
  description = "Topic IAM memberships managed by this deployment."
  value       = module.pubsub.topic_iam_members
}

output "subscription_iam_members" {
  description = "Subscription IAM memberships managed by this deployment."
  value       = module.pubsub.subscription_iam_members
}
