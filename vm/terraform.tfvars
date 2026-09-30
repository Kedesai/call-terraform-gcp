# -----------------------------------------------------------------------------
# Environment-Specific Terraform Variables
#
# Environment-specific values are intentionally not stored in this repository.
#
# Supply values through HCP Terraform workspace or project-level variable sets,
# or another approved configuration mechanism.
#
# Example:
#
# project_id    = "my-gcp-project"
# region        = "us-central1"
#
# instance_name = "application-vm"
# zone          = "us-central1-a"
# machine_type  = "e2-medium"
#
# boot_disk_image   = "debian-cloud/debian-12"
# boot_disk_size_gb = 20
# boot_disk_type    = "pd-balanced"
#
# subnetwork_self_link = "projects/.../regions/.../subnetworks/..."
#
# Optional service account:
#
# service_account_email = "application-sa@my-project.iam.gserviceaccount.com"
#
# Optional boot-disk CMEK:
#
# kms_key_id = "projects/.../locations/.../keyRings/.../cryptoKeys/..."
#
# Optional metadata:
#
# metadata = {
#   enable-oslogin = "TRUE"
# }
#
# Optional startup script:
#
# startup_script = <<-EOT
#   #!/usr/bin/env bash
#   apt-get update
# EOT
#
# Standard instance scheduling:
#
# provisioning_model  = "STANDARD"
# automatic_restart   = true
# on_host_maintenance = "MIGRATE"
#
# Spot instance scheduling:
#
# provisioning_model  = "SPOT"
# automatic_restart   = false
# on_host_maintenance = "TERMINATE"
#
# labels = {
#   managed_by  = "terraform"
#   environment = "dev"
#   application = "example"
# }
# -----------------------------------------------------------------------------
