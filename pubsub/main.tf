# -----------------------------------------------------------------------------
# Reusable GCP Pub/Sub Module
#
# This caller translates simple workspace variables into the map-based
# interface expected by the reusable Pub/Sub module.
#
# Optional dependencies are consumed through HCP Terraform workspace outputs:
#
# - KMS Crypto Key
# - Publisher service-account member
# - Subscriber service-account member
# -----------------------------------------------------------------------------

module "pubsub" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/pubsub"

  # ---------------------------------------------------------------------------
  # GCP Project
  # ---------------------------------------------------------------------------

  project_id = var.project_id


  # ---------------------------------------------------------------------------
  # Topics
  #
  # local.topics always contains the logical "primary" topic.
  #
  # It also contains "dead_letter" when dead-letter handling is enabled.
  # ---------------------------------------------------------------------------

  topics = local.topics


  # ---------------------------------------------------------------------------
  # Pull Subscription
  #
  # This caller creates one logical subscription named "primary".
  # ---------------------------------------------------------------------------

  subscriptions = local.subscriptions


  # ---------------------------------------------------------------------------
  # Optional Resource-Level IAM
  #
  # These maps are empty when no publisher or subscriber members are supplied.
  # ---------------------------------------------------------------------------

  topic_iam_bindings = local.topic_iam_bindings

  subscription_iam_bindings = (
    local.subscription_iam_bindings
  )
}
