# -----------------------------------------------------------------------------
# Global External HTTP Load Balancer Caller
#
# The caller retrieves the Managed Instance Group backend from an upstream HCP
# Terraform workspace and passes environment-specific configuration to the
# reusable load-balancer module.
# -----------------------------------------------------------------------------

module "load_balancer" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/load-balancer"

  # ---------------------------------------------------------------------------
  # Project and Identity
  # ---------------------------------------------------------------------------

  project_id = var.project_id
  name       = var.name


  # ---------------------------------------------------------------------------
  # Managed Instance Group Backend
  # ---------------------------------------------------------------------------

  backend_instance_group = (
    local.backend_instance_group
  )

  backend_protocol = (
    var.backend_protocol
  )

  port_name = var.port_name

  timeout_sec = (
    var.timeout_sec
  )

  enable_cdn = (
    var.enable_cdn
  )


  # ---------------------------------------------------------------------------
  # Backend Balancing
  # ---------------------------------------------------------------------------

  balancing_mode = (
    var.balancing_mode
  )

  capacity_scaler = (
    var.capacity_scaler
  )

  max_utilization = (
    var.max_utilization
  )


  # ---------------------------------------------------------------------------
  # HTTP Health Check
  # ---------------------------------------------------------------------------

  health_check_port = (
    var.health_check_port
  )

  health_check_request_path = (
    var.health_check_request_path
  )

  health_check_interval_sec = (
    var.health_check_interval_sec
  )

  health_check_timeout_sec = (
    var.health_check_timeout_sec
  )

  healthy_threshold = (
    var.healthy_threshold
  )

  unhealthy_threshold = (
    var.unhealthy_threshold
  )


  # ---------------------------------------------------------------------------
  # Logging
  # ---------------------------------------------------------------------------

  enable_logging = (
    var.enable_logging
  )

  log_sample_rate = (
    var.log_sample_rate
  )
}
