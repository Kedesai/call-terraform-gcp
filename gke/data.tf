# -----------------------------------------------------------------------------
# Foundation Networking Outputs
#
# Reads the VPC network and subnet outputs from the upstream HCP Terraform
# networking workspace.
#
# The upstream workspace must expose:
#
# - network_self_link
# - subnet_self_links
#
# subnet_self_links is expected to be a map keyed by the logical subnet names
# used by the VPC caller.
# -----------------------------------------------------------------------------

data "tfe_outputs" "network" {
  organization = var.hcp_organization
  workspace    = var.network_workspace_name
}


# -----------------------------------------------------------------------------
# Optional Service Account Outputs
#
# The data source is created only when use_service_account_workspace is true.
#
# The upstream workspace must expose:
#
# - service_account_email
# -----------------------------------------------------------------------------

data "tfe_outputs" "service_account" {
  count = var.use_service_account_workspace ? 1 : 0

  organization = var.hcp_organization
  workspace    = var.service_account_workspace_name
}


# -----------------------------------------------------------------------------
# Optional KMS Outputs
#
# The data source is created only when use_kms_workspace is true.
#
# The upstream workspace must expose:
#
# - crypto_key_id
# -----------------------------------------------------------------------------

data "tfe_outputs" "kms" {
  count = var.use_kms_workspace ? 1 : 0

  organization = var.hcp_organization
  workspace    = var.kms_workspace_name
}
