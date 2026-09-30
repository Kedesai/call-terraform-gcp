# -----------------------------------------------------------------------------
# VPC Workspace Outputs
#
# The upstream VPC workspace must expose:
#
# - network_id
# - network_name
#
# These outputs are already part of our current VPC caller contract.
# -----------------------------------------------------------------------------

data "tfe_outputs" "vpc" {
  organization = var.hcp_organization
  workspace    = var.vpc_workspace_name
}
