# -----------------------------------------------------------------------------
# Reusable GCP VM Module
#
# This caller consumes the reusable VM module maintained in:
#
#   Kedesai/terraform/gcp/vm
#
# The reusable module supports multiple VM instances. This caller exposes a
# simpler one-VM-per-workspace interface suitable for HCP Terraform.
#
# Networking, service accounts and KMS keys are created independently and
# supplied to this caller as inputs.
# -----------------------------------------------------------------------------

module "vm" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/vm"

  # ---------------------------------------------------------------------------
  # GCP Project
  # ---------------------------------------------------------------------------

  project_id = var.project_id

  # ---------------------------------------------------------------------------
  # VM Definition
  #
  # The reusable module accepts a map because it can create multiple VMs.
  #
  # This caller creates one logical VM named "main".
  #
  # "main" is only an internal Terraform key. The actual Compute Engine
  # instance name comes from var.instance_name.
  # ---------------------------------------------------------------------------

  instances = {
    main = {
      # -----------------------------------------------------------------------
      # Basic VM Configuration
      # -----------------------------------------------------------------------

      name         = var.instance_name
      zone         = var.zone
      machine_type = var.machine_type
      description  = var.description

      labels = var.labels

      # The caller accepts a set to remove duplicate tags. The reusable module
      # receives an explicit list.
      tags = tolist(var.network_tags)

      # -----------------------------------------------------------------------
      # VM Protection and Update Behavior
      # -----------------------------------------------------------------------

      deletion_protection       = var.deletion_protection
      allow_stopping_for_update = var.allow_stopping_for_update
      can_ip_forward            = var.can_ip_forward

      # -----------------------------------------------------------------------
      # Boot Disk
      #
      # kms_key_id is optional. When null, the reusable module does not request
      # customer-managed encryption for the boot disk.
      # -----------------------------------------------------------------------

      boot_disk = {
        image       = var.boot_disk_image
        size_gb     = var.boot_disk_size_gb
        type        = var.boot_disk_type
        auto_delete = var.boot_disk_auto_delete

        kms_key_id = var.kms_key_id
        labels     = var.labels
      }

      # -----------------------------------------------------------------------
      # Network Interface
      #
      # This caller expects an existing subnet created or discovered by the
      # VPC layer.
      #
      # External IP assignment is disabled by default.
      # -----------------------------------------------------------------------

      network_interface = {
        subnetwork = var.subnetwork_self_link
        network_ip = var.private_ip_address

        assign_external_ip = var.assign_external_ip
        network_tier       = upper(var.network_tier)
      }

      # -----------------------------------------------------------------------
      # Service Account
      #
      # When service_account_email is null, the reusable VM module receives
      # null and does not generate its custom service-account block.
      #
      # The caller accepts scopes as a set to prevent duplicate values and
      # translates the set into a list for the reusable module boundary.
      # -----------------------------------------------------------------------

      service_account = var.service_account_email != null ? {
        email  = var.service_account_email
        scopes = tolist(var.service_account_scopes)
      } : null

      # -----------------------------------------------------------------------
      # Metadata and Startup Script
      #
      # Sensitive values must not be stored in metadata or startup scripts.
      # -----------------------------------------------------------------------

      metadata       = var.metadata
      startup_script = var.startup_script

      # -----------------------------------------------------------------------
      # Scheduling
      # -----------------------------------------------------------------------

      scheduling = {
        automatic_restart   = var.automatic_restart
        on_host_maintenance = upper(var.on_host_maintenance)
        preemptible         = var.preemptible
        provisioning_model  = upper(var.provisioning_model)
      }

      # -----------------------------------------------------------------------
      # Shielded VM Configuration
      # -----------------------------------------------------------------------

      shielded_instance_config = {
        enable_secure_boot          = var.enable_secure_boot
        enable_vtpm                 = var.enable_vtpm
        enable_integrity_monitoring = var.enable_integrity_monitoring
      }
    }
  }
}
