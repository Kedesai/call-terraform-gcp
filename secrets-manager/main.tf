# -----------------------------------------------------------------------------
# Reusable GCP Secret Manager Module
#
# This caller consumes the reusable Secret Manager module maintained in the
# central Terraform repository.
#
# Reusable module:
#
#   Kedesai/terraform/gcp/secret-manager
#
# Caller:
#
#   Kedesai/call-gcp-terraform/secret-manager
#
# The reusable module provides the Secret Manager implementation and supports
# multiple secrets and advanced configuration.
#
# This caller intentionally exposes a simpler interface suitable for an HCP
# Terraform workspace.
# -----------------------------------------------------------------------------

module "secret_manager" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/secret-manager"

  # ---------------------------------------------------------------------------
  # GCP Project
  #
  # Determines the GCP project where the Secret Manager resource is managed.
  # ---------------------------------------------------------------------------

  project_id = var.project_id


  # ---------------------------------------------------------------------------
  # Secret Definition
  #
  # The reusable module accepts a map of secrets so that it can create multiple
  # secrets when required.
  #
  # This caller currently manages one secret and uses the logical map key:
  #
  #   main
  #
  # "main" is an internal Terraform identifier only.
  #
  # The actual Secret Manager resource name in GCP comes from:
  #
  #   var.secret_id
  # ---------------------------------------------------------------------------

  secrets = {
    main = {
      secret_id        = var.secret_id
      replication_type = var.replication_type


      # -----------------------------------------------------------------------
      # Automatic Replication CMEK
      #
      # kms_key_id is passed to the reusable module only when AUTOMATIC
      # replication is selected.
      #
      # The reusable module uses the provider-oriented property name
      # automatic_kms_key_name, while the caller uses the platform-standard
      # kms_key_id input.
      #
      # When kms_key_id is null, no customer-managed key is passed.
      # -----------------------------------------------------------------------

      automatic_kms_key_name = (
        upper(var.replication_type) == "AUTOMATIC"
        ? var.kms_key_id
        : null
      )


      # -----------------------------------------------------------------------
      # User-Managed Replication
      #
      # Replica definitions are passed only when USER_MANAGED replication
      # is selected.
      #
      # Otherwise an empty list is passed to the reusable module.
      # -----------------------------------------------------------------------

      user_managed_replicas = (
        upper(var.replication_type) == "USER_MANAGED"
        ? var.user_managed_replicas
        : []
      )


      # -----------------------------------------------------------------------
      # Labels
      # -----------------------------------------------------------------------

      labels = var.labels
    }
  }


  # ---------------------------------------------------------------------------
  # Secret-Level IAM
  #
  # IAM configuration is completely optional.
  #
  # If iam_members is empty:
  #
  #   secret_iam_bindings = {}
  #
  # and the reusable module creates no IAM membership resources.
  #
  # If IAM members are supplied, one logical binding named "main_access" is
  # constructed and passed to the reusable module.
  #
  # The secret property references the logical secret key "main" defined
  # above rather than the actual Secret Manager secret_id.
  # ---------------------------------------------------------------------------

  secret_iam_bindings = length(var.iam_members) > 0 ? {
    main_access = {
      secret  = "main"
      role    = var.iam_role
      members = var.iam_members
    }
  } : {}
}
