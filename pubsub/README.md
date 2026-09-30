GCP Pub/Sub Caller
Terraform caller for deploying one Pub/Sub topic and one pull subscription using the reusable GCP Pub/Sub module.

The caller optionally supports:

KMS CMEK retrieved through tfe_outputs
Publisher service account retrieved through tfe_outputs
Subscriber service account retrieved through tfe_outputs
Additional publisher and subscriber IAM members
Retry policy
Message retention
Filtering
Message ordering
Dead-letter topic
Architecture
KMS workspace
    |
    +-- crypto_key_id
              |
              v
Publisher SA workspace ---> Pub/Sub caller <--- Subscriber SA workspace
    |                            |                    |
    +-- service_account_member   |                    +-- service_account_member
                                 |
                                 v
                       Reusable Pub/Sub module
                                 |
                     +-----------+------------+
                     |                        |
                     v                        v
                   Topic                Subscription
                     |
                     +-- Optional dead-letter topic
Required Variables
project_id       = "my-gcp-project"
hcp_organization = "my-hcp-organization"

topic_name        = "application-events"
subscription_name = "application-events-subscription"
KMS Workspace
use_kms_workspace = true
kms_workspace_name = "gcp-kms"
The upstream workspace must expose:

output "crypto_key_id" {
  value = module.kms.crypto_key_ids["main"]
}
Publisher Workspace
use_publisher_workspace  = true
publisher_workspace_name = "gcp-publisher-service-account"
The workspace must expose:

output "service_account_member" {
  value = module.service_account.member
}
Subscriber Workspace
use_subscriber_workspace  = true
subscriber_workspace_name = "gcp-subscriber-service-account"
The workspace must expose:

output "service_account_member" {
  value = module.service_account.member
}
Dead-Letter Topic
enable_dead_letter_topic = true
dead_letter_topic_name   = "application-events-dead-letter"
max_delivery_attempts    = 10
Creating the dead-letter relationship does not automatically configure all Google-managed Pub/Sub service-agent IAM permissions required for forwarding. Those permissions remain an IAM/orchestration responsibility.

HCP Output Access
The Pub/Sub workspace must be authorized to read outputs from every enabled upstream workspace.

KMS workspace             -> Pub/Sub workspace
Publisher SA workspace    -> Pub/Sub workspace
Subscriber SA workspace   -> Pub/Sub workspace
HCP Workspace
Suggested workspace:

gcp-pubsub
Repository:

Kedesai/call-gcp-terraform
Working directory:

pubsub
Outputs
topic_id
topic_name
subscription_id
subscription_name
subscription_topic
dead_letter_topic_id
dead_letter_topic_name
topic_iam_members
subscription_iam_members
Validation
terraform fmt -recursive
terraform init
terraform validate
terraform plan
Design Principles
Pub/Sub implementation remains in the reusable module
HCP dependency wiring remains in the caller
KMS keys are consumed rather than recreated
Service accounts are consumed rather than recreated
IAM grants are optional
Dead-letter routing is optional
HCP output sharing and run triggers remain separate concerns

Upstream service-account output check

Our existing service-account caller already exposes:

output "service_account_member" {
  value = module.service_account.member
}

That matches what this Pub/Sub caller expects.

The optional KMS workspace likewise exposes:

output "crypto_key_id" {
  value = module.kms.crypto_key_ids["main"]
}