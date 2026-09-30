# -----------------------------------------------------------------------------
# Instance Template Workspace
#
# Required upstream output:
#
# instance_template_self_link
# -----------------------------------------------------------------------------

data "tfe_outputs" "instance_template" {
  organization = var.hcp_organization
  workspace    = var.instance_template_workspace_name
}


# -----------------------------------------------------------------------------
# Optional Health Check Workspace
#
# Required upstream output when enabled:
#
# health_check_id
# -----------------------------------------------------------------------------

data "tfe_outputs" "health_check" {
  count = var.use_health_check_workspace ? 1 : 0

  organization = var.hcp_organization
  workspace    = var.health_check_workspace_name
}
