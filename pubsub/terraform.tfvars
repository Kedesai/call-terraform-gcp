# -----------------------------------------------------------------------------
# Environment-Specific Terraform Variables
#
# Supply these values through HCP Terraform workspace or project variable sets.
#
# Required:
#
# project_id       = "my-gcp-project"
# hcp_organization = "my-hcp-organization"
#
# topic_name        = "application-events"
# subscription_name = "application-events-subscription"
#
# Optional KMS output consumption:
#
# use_kms_workspace = true
# kms_workspace_name = "gcp-kms"
#
# Optional publisher identity:
#
# use_publisher_workspace  = true
# publisher_workspace_name = "gcp-publisher-service-account"
#
# Optional subscriber identity:
#
# use_subscriber_workspace  = true
# subscriber_workspace_name = "gcp-subscriber-service-account"
#
# Optional dead-letter topic:
#
# enable_dead_letter_topic = true
# dead_letter_topic_name   = "application-events-dead-letter"
# max_delivery_attempts    = 10
#
# Additional IAM members:
#
# additional_publisher_members = [
#   "serviceAccount:publisher@my-project.iam.gserviceaccount.com"
# ]
#
# additional_subscriber_members = [
#   "serviceAccount:subscriber@my-project.iam.gserviceaccount.com"
# ]
# -----------------------------------------------------------------------------
