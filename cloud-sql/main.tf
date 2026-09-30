# -----------------------------------------------------------------------------
# Reusable Cloud SQL Module
#
# This caller provides environment-specific settings and resolves optional HCP
# Terraform dependencies.
#
# Cloud SQL implementation remains in:
#
#   Kedesai/terraform/gcp/cloud-sql
# -----------------------------------------------------------------------------

module "cloud_sql" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/cloud-sql"

  # ---------------------------------------------------------------------------
  # Project and Instance
  # ---------------------------------------------------------------------------

  project_id = var.project_id

  instance_name    = var.instance_name
  region           = var.region
  database_version = var.database_version
  tier             = var.tier

  availability_type = var.availability_type
  edition           = var.edition

  # ---------------------------------------------------------------------------
  # Private Networking
  #
  # Private Service Access and Service Networking must already exist.
  # ---------------------------------------------------------------------------

  private_network    = var.private_network
  allocated_ip_range = var.allocated_ip_range

  enable_private_path_for_google_cloud_services = (
    var.enable_private_path_for_google_cloud_services
  )

  # ---------------------------------------------------------------------------
  # Public Connectivity and SSL
  # ---------------------------------------------------------------------------

  ipv4_enabled = var.ipv4_enabled
  ssl_mode     = var.ssl_mode

  authorized_networks = (
    var.authorized_networks
  )

  # ---------------------------------------------------------------------------
  # Storage
  # ---------------------------------------------------------------------------

  disk_type             = var.disk_type
  disk_size_gb          = var.disk_size_gb
  disk_autoresize       = var.disk_autoresize
  disk_autoresize_limit = var.disk_autoresize_limit

  # ---------------------------------------------------------------------------
  # Automated Backups
  # ---------------------------------------------------------------------------

  backup_enabled    = var.backup_enabled
  backup_start_time = var.backup_start_time
  backup_location   = var.backup_location
  retained_backups  = var.retained_backups

  # ---------------------------------------------------------------------------
  # Engine-Specific Recovery
  #
  # The reusable module determines which settings apply based on the selected
  # database_version.
  # ---------------------------------------------------------------------------

  binary_log_enabled = (
    var.binary_log_enabled
  )

  point_in_time_recovery_enabled = (
    var.point_in_time_recovery_enabled
  )

  transaction_log_retention_days = (
    var.transaction_log_retention_days
  )

  # ---------------------------------------------------------------------------
  # Maintenance
  # ---------------------------------------------------------------------------

  maintenance_window_day = (
    var.maintenance_window_day
  )

  maintenance_window_hour = (
    var.maintenance_window_hour
  )

  maintenance_update_track = (
    var.maintenance_update_track
  )

  # ---------------------------------------------------------------------------
  # Database Configuration
  # ---------------------------------------------------------------------------

  database_flags = var.database_flags
  databases      = var.databases

  # ---------------------------------------------------------------------------
  # Optional Customer-Managed Encryption
  #
  # local.encryption_key_name is populated from the optional KMS workspace.
  # ---------------------------------------------------------------------------

  encryption_key_name = (
    local.encryption_key_name
  )

  # ---------------------------------------------------------------------------
  # Labels and Protection
  # ---------------------------------------------------------------------------

  user_labels         = var.user_labels
  deletion_protection = var.deletion_protection
}
