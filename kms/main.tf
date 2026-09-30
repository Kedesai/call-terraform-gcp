# -----------------------------------------------------------------------------
# Reusable GCP KMS Module
#
# This caller consumes the reusable KMS module stored in the central Terraform
# repository. The reusable module owns the implementation of the Key Ring and
# Crypto Key resources, while this caller supplies environment-specific values.
#
# This separation allows the same reusable KMS implementation to be consumed
# by multiple projects and environments without duplicating resource logic.
# -----------------------------------------------------------------------------

module "kms" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/kms"

  # ---------------------------------------------------------------------------
  # Project and Location
  # ---------------------------------------------------------------------------

  project_id = var.project_id
  location   = var.kms_location

  # ---------------------------------------------------------------------------
  # Key Ring
  #
  # This caller currently creates the Key Ring.
  # The reusable module also supports consuming an existing Key Ring when
  # required by another environment or the future GCP Landing Zone.
  # ---------------------------------------------------------------------------

  create_key_ring = true
  key_ring_name   = var.key_ring_name

  # ---------------------------------------------------------------------------
  # Crypto Keys
  #
  # The reusable module accepts a map of Crypto Keys so that it can support
  # multiple keys when required.
  #
  # This caller intentionally exposes a simpler interface and creates one
  # logical key named "main". Environment-specific properties are supplied
  # through normal Terraform/HCP Terraform variables.
  #
  # The "main" key is only the Terraform map identifier. The actual GCP Crypto
  # Key name is controlled by var.key_name.
  # ---------------------------------------------------------------------------

  keys = {
    main = {
      name                       = var.key_name
      purpose                    = var.key_purpose
      rotation_period            = var.rotation_period
      destroy_scheduled_duration = var.destroy_scheduled_duration
      labels                     = var.labels
    }
  }
}
