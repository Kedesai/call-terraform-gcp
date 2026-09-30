# -----------------------------------------------------------------------------
# Upstream Dependency Resolution
# -----------------------------------------------------------------------------

locals {
  instance_template_self_link = (
    data.tfe_outputs.instance_template
    .nonsensitive_values
    .instance_template_self_link
  )

  health_check_id = (
    var.use_health_check_workspace
    ? data.tfe_outputs.health_check[0]
    .nonsensitive_values
    .health_check_id
    : null
  )
}
