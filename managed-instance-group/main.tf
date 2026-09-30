# -----------------------------------------------------------------------------
# GCP Regional Managed Instance Group Caller
#
# This caller consumes upstream HCP Terraform workspace outputs and passes
# deployment-specific configuration to the reusable regional MIG module.
#
# Reusable module:
#
#   Kedesai/terraform/gcp/managed-instance-group
#
# This caller does not create:
#
# - Instance templates
# - Health checks
# - VPC resources
# - Service accounts
# - Firewall rules
# - Load balancers
# -----------------------------------------------------------------------------


# =============================================================================
# REGIONAL MANAGED INSTANCE GROUP
# =============================================================================

module "managed_instance_group" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/managed-instance-group"

  # ---------------------------------------------------------------------------
  # Project and Region
  # ---------------------------------------------------------------------------

  project_id = var.project_id
  region     = var.region


  # ---------------------------------------------------------------------------
  # Managed Instance Group Identity
  # ---------------------------------------------------------------------------

  name = var.name

  description = (
    var.description
  )

  base_instance_name = (
    var.base_instance_name
  )

  version_name = (
    var.version_name
  )


  # ---------------------------------------------------------------------------
  # Existing Instance Template
  #
  # Resolved from the upstream instance-template HCP Terraform workspace.
  # ---------------------------------------------------------------------------

  instance_template_self_link = (
    local.instance_template_self_link
  )


  # ---------------------------------------------------------------------------
  # Regional Distribution
  # ---------------------------------------------------------------------------

  distribution_policy_zones = (
    var.distribution_policy_zones
  )

  distribution_policy_target_shape = (
    var.distribution_policy_target_shape
  )


  # ---------------------------------------------------------------------------
  # Initial / Configured Group Size
  #
  # The reusable module protects target_size from autoscaler-driven drift
  # through lifecycle.ignore_changes.
  # ---------------------------------------------------------------------------

  target_size = (
    var.target_size
  )


  # ---------------------------------------------------------------------------
  # Instance Readiness
  # ---------------------------------------------------------------------------

  wait_for_instances = (
    var.wait_for_instances
  )

  wait_for_instances_status = (
    var.wait_for_instances_status
  )


  # ---------------------------------------------------------------------------
  # Named Ports
  #
  # These ports become named ports on the underlying instance group and can
  # later be consumed by load-balancing backend services.
  # ---------------------------------------------------------------------------

  named_ports = (
    var.named_ports
  )


  # ---------------------------------------------------------------------------
  # Autohealing
  #
  # health_check_id resolves to null when the optional health-check workspace
  # dependency is disabled.
  #
  # The reusable module validates that health_check_id is present whenever
  # enable_autohealing is true.
  # ---------------------------------------------------------------------------

  enable_autohealing = (
    var.enable_autohealing
  )

  health_check_id = (
    local.health_check_id
  )

  initial_delay_sec = (
    var.initial_delay_sec
  )


  # ---------------------------------------------------------------------------
  # Rolling Update Policy
  # ---------------------------------------------------------------------------

  update_type = (
    var.update_type
  )

  minimal_action = (
    var.minimal_action
  )

  most_disruptive_allowed_action = (
    var.most_disruptive_allowed_action
  )

  replacement_method = (
    var.replacement_method
  )

  max_surge_fixed = (
    var.max_surge_fixed
  )

  max_unavailable_fixed = (
    var.max_unavailable_fixed
  )


  # ---------------------------------------------------------------------------
  # Regional CPU Autoscaling
  # ---------------------------------------------------------------------------

  enable_autoscaling = (
    var.enable_autoscaling
  )

  autoscaler_name = (
    var.autoscaler_name
  )

  min_replicas = (
    var.min_replicas
  )

  max_replicas = (
    var.max_replicas
  )

  cooldown_period_sec = (
    var.cooldown_period_sec
  )

  cpu_utilization_target = (
    var.cpu_utilization_target
  )
}
