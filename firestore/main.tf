# -----------------------------------------------------------------------------
# Reusable Firestore Module
#
# Resource implementation resides in:
#
#   Kedesai/terraform/gcp/firestore
#
# This caller contains only deployment-specific configuration.
# -----------------------------------------------------------------------------

module "firestore" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/firestore"

  # ---------------------------------------------------------------------------
  # Project and Database Identity
  # ---------------------------------------------------------------------------

  project_id = var.project_id

  database_name = var.database_name
  location_id   = var.location_id
  database_type = var.database_type


  # ---------------------------------------------------------------------------
  # Database Behavior
  # ---------------------------------------------------------------------------

  concurrency_mode = var.concurrency_mode

  app_engine_integration_mode = (
    var.app_engine_integration_mode
  )


  # ---------------------------------------------------------------------------
  # Recovery and Protection
  # ---------------------------------------------------------------------------

  enable_point_in_time_recovery = (
    var.enable_point_in_time_recovery
  )

  delete_protection = var.delete_protection
  deletion_policy   = var.deletion_policy


  # ---------------------------------------------------------------------------
  # Resource Manager Tags
  # ---------------------------------------------------------------------------

  tags = var.tags
}
