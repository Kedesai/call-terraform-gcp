# -----------------------------------------------------------------------------
# Reusable GCP GKE Module
#
# This caller consumes:
#
# - Network and subnet values from an upstream HCP Terraform workspace
# - An optional node service account from another HCP Terraform workspace
# - An optional KMS key from another HCP Terraform workspace
#
# The retrieved outputs are passed to the reusable GKE module maintained in:
#
#   Kedesai/terraform/gcp/gke
#
# HCP Terraform orchestration remains in this caller. The reusable GKE module
# remains independent of HCP Terraform.
# -----------------------------------------------------------------------------

module "gke" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/gke"

  # ---------------------------------------------------------------------------
  # GCP Project and Cluster Identity
  # ---------------------------------------------------------------------------

  project_id = var.project_id

  cluster_name = var.cluster_name
  location     = var.cluster_location
  description  = var.cluster_description

  deletion_protection = var.deletion_protection
  resource_labels     = var.resource_labels


  # ---------------------------------------------------------------------------
  # Foundation Network Outputs
  #
  # network_self_link is a scalar output from the VPC workspace.
  #
  # subnet_self_links is a map. network_subnet_key selects the subnet intended
  # for GKE, such as:
  #
  #   subnet_self_links["gke"]
  # ---------------------------------------------------------------------------

  network = (
    data.tfe_outputs.network
    .nonsensitive_values
    .network_self_link
  )

  subnetwork = (
    data.tfe_outputs.network
    .nonsensitive_values
    .subnet_self_links[var.network_subnet_key]
  )

  networking_mode = "VPC_NATIVE"


  # ---------------------------------------------------------------------------
  # VPC-Native Secondary Range Names
  #
  # These named ranges must already exist on the selected foundation subnet.
  # ---------------------------------------------------------------------------

  cluster_secondary_range_name  = var.cluster_secondary_range_name
  services_secondary_range_name = var.services_secondary_range_name


  # ---------------------------------------------------------------------------
  # Private Cluster Configuration
  # ---------------------------------------------------------------------------

  enable_private_nodes         = var.enable_private_nodes
  enable_private_endpoint      = var.enable_private_endpoint
  master_ipv4_cidr_block       = var.master_ipv4_cidr_block
  master_global_access_enabled = var.master_global_access_enabled

  master_authorized_networks = var.master_authorized_networks


  # ---------------------------------------------------------------------------
  # Release, Identity, and Security Configuration
  # ---------------------------------------------------------------------------

  release_channel = var.release_channel

  enable_workload_identity    = var.enable_workload_identity
  enable_shielded_nodes       = var.enable_shielded_nodes
  enable_network_policy       = var.enable_network_policy
  enable_intranode_visibility = var.enable_intranode_visibility


  # ---------------------------------------------------------------------------
  # Cluster Logging and Monitoring
  # ---------------------------------------------------------------------------

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service


  # ---------------------------------------------------------------------------
  # Optional Database Encryption Key from KMS Workspace
  #
  # When use_kms_workspace is false, null is passed and the reusable module
  # omits the GKE database_encryption block.
  # ---------------------------------------------------------------------------

  database_encryption_key_id = var.use_kms_workspace ? (
    data.tfe_outputs.kms[0]
    .nonsensitive_values
    .crypto_key_id
  ) : null


  # ---------------------------------------------------------------------------
  # Maintenance Window
  # ---------------------------------------------------------------------------

  maintenance_start_time = var.maintenance_start_time
  maintenance_end_time   = var.maintenance_end_time
  maintenance_recurrence = var.maintenance_recurrence


  # ---------------------------------------------------------------------------
  # System Node Pool
  #
  # The reusable module supports multiple independently managed node pools.
  #
  # This caller initially creates one logical system pool.
  # ---------------------------------------------------------------------------

  node_pools = {
    system = {
      name = var.node_pool_name

      node_locations     = var.node_locations
      initial_node_count = var.initial_node_count

      autoscaling = {
        enabled   = var.enable_node_autoscaling
        min_count = var.node_min_count
        max_count = var.node_max_count
      }

      auto_repair  = var.node_auto_repair
      auto_upgrade = var.node_auto_upgrade

      max_surge       = var.node_max_surge
      max_unavailable = var.node_max_unavailable

      machine_type = var.node_machine_type
      disk_size_gb = var.node_disk_size_gb
      disk_type    = var.node_disk_type
      image_type   = var.node_image_type

      # -----------------------------------------------------------------------
      # Optional Node Service Account
      #
      # When the optional workspace is disabled, null is passed. For platform
      # deployments, a dedicated node service account is recommended.
      # -----------------------------------------------------------------------

      service_account_email = var.use_service_account_workspace ? (
        data.tfe_outputs.service_account[0]
        .nonsensitive_values
        .service_account_email
      ) : null

      oauth_scopes = tolist(var.node_oauth_scopes)

      labels   = var.node_labels
      metadata = var.node_metadata
      tags     = tolist(var.node_network_tags)

      enable_secure_boot          = var.node_enable_secure_boot
      enable_integrity_monitoring = var.node_enable_integrity_monitoring

      spot = var.node_spot
    }
  }
}
