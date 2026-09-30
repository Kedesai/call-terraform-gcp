# -----------------------------------------------------------------------------
# Managed Instance Group Workspace
#
# Required output:
#
# instance_group
# -----------------------------------------------------------------------------

data "tfe_outputs" "mig" {
  organization = var.hcp_organization
  workspace    = var.mig_workspace_name
}
