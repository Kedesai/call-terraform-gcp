# -----------------------------------------------------------------------------
# Optional KMS Workspace Outputs
#
# The upstream workspace must expose:
#
#   crypto_key_id
# -----------------------------------------------------------------------------

data "tfe_outputs" "kms" {
  count = var.use_kms_workspace ? 1 : 0

  organization = var.hcp_organization
  workspace    = var.kms_workspace_name
}


# -----------------------------------------------------------------------------
# Optional Publisher Service Account Output
#
# The upstream workspace must expose:
#
#   service_account_member
# -----------------------------------------------------------------------------

data "tfe_outputs" "publisher" {
  count = var.use_publisher_workspace ? 1 : 0

  organization = var.hcp_organization
  workspace    = var.publisher_workspace_name
}


# -----------------------------------------------------------------------------
# Optional Subscriber Service Account Output
#
# The upstream workspace must expose:
#
#   service_account_member
# -----------------------------------------------------------------------------

data "tfe_outputs" "subscriber" {
  count = var.use_subscriber_workspace ? 1 : 0

  organization = var.hcp_organization
  workspace    = var.subscriber_workspace_name
}
