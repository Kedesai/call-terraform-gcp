# -----------------------------------------------------------------------------
# Optional KMS Workspace
#
# Expected upstream output:
#
#   crypto_key_id
# -----------------------------------------------------------------------------

data "tfe_outputs" "kms" {
  count = var.use_kms_workspace ? 1 : 0

  organization = var.hcp_organization
  workspace    = var.kms_workspace_name
}
