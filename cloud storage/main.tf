# -----------------------------------------------------------------------------
# Reusable GCP Cloud Storage Module
#
# This caller consumes the reusable Cloud Storage module maintained in:
#
#   Kedesai/terraform/gcp/cloud-storage
#
# The reusable module contains the actual Google Cloud Storage resource logic.
# This caller supplies deployment-specific configuration and provides a simpler
# interface suitable for HCP Terraform.
#
# The reusable module can manage multiple buckets, but this caller intentionally
# manages one logical bucket per workspace.
# -----------------------------------------------------------------------------

module "cloud_storage" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/cloud-storage"

  # ---------------------------------------------------------------------------
  # GCP Project
  #
  # Specifies the project where the Cloud Storage bucket will be created.
  # ---------------------------------------------------------------------------

  project_id = var.project_id


  # ---------------------------------------------------------------------------
  # Cloud Storage Bucket
  #
  # The reusable module accepts a map of buckets so that it remains flexible
  # enough to support multiple buckets when required.
  #
  # This caller creates one logical bucket named "main".
  #
  # "main" is only the internal Terraform map key.
  # The actual globally unique GCP bucket name comes from var.bucket_name.
  # ---------------------------------------------------------------------------

  buckets = {
    main = {

      # -----------------------------------------------------------------------
      # Basic Bucket Configuration
      # -----------------------------------------------------------------------

      name          = var.bucket_name
      location      = var.bucket_location
      storage_class = var.storage_class


      # -----------------------------------------------------------------------
      # Bucket Deletion Protection
      #
      # force_destroy defaults to false in the caller.
      #
      # With force_destroy disabled, Terraform will not automatically remove
      # objects simply to delete the bucket.
      # -----------------------------------------------------------------------

      force_destroy = var.force_destroy


      # -----------------------------------------------------------------------
      # Bucket Access Controls
      #
      # Uniform bucket-level access makes IAM the primary access-control model.
      #
      # Public access prevention defaults to "enforced" in variables.tf.
      # -----------------------------------------------------------------------

      uniform_bucket_level_access = var.uniform_bucket_level_access
      public_access_prevention    = var.public_access_prevention


      # -----------------------------------------------------------------------
      # Object Versioning
      #
      # Versioning is optional and controlled by the caller.
      # -----------------------------------------------------------------------

      versioning_enabled = var.versioning_enabled


      # -----------------------------------------------------------------------
      # Customer-Managed Encryption Key (CMEK)
      #
      # Our GCP caller convention uses:
      #
      #   kms_key_id
      #
      # The reusable Cloud Storage module uses:
      #
      #   kms_key_name
      #
      # This caller performs the translation between the platform-facing
      # variable name and the Google-provider-oriented module property.
      #
      # When var.kms_key_id is null, the reusable module omits its encryption
      # block and the bucket uses the default encryption configuration.
      # -----------------------------------------------------------------------

      kms_key_name = var.kms_key_id


      # -----------------------------------------------------------------------
      # Resource Labels
      #
      # Labels are supplied by the caller and can identify environment,
      # workload, ownership, or Terraform management information.
      # -----------------------------------------------------------------------

      labels = var.labels


      # -----------------------------------------------------------------------
      # Object Lifecycle Rules
      #
      # Lifecycle rules are optional.
      #
      # Examples include:
      #
      # - Transitioning older objects to another storage class
      # - Deleting objects after a configured age
      # - Managing non-current object versions
      #
      # When var.lifecycle_rules is empty, the reusable module creates no
      # lifecycle_rule blocks.
      # -----------------------------------------------------------------------

      lifecycle_rules = var.lifecycle_rules
    }
  }


  # ---------------------------------------------------------------------------
  # Bucket-Level IAM
  #
  # IAM configuration is optional.
  #
  # If var.iam_members is empty, an empty map is passed to the reusable module
  # and no bucket IAM resources are created.
  #
  # When IAM members are supplied, the caller creates one logical binding named:
  #
  #   main_access
  #
  # The reusable module then expands the members into individual IAM member
  # resources.
  #
  # The bucket value "main" references the logical bucket key defined in the
  # buckets map above. It does not duplicate the actual bucket name.
  # ---------------------------------------------------------------------------

  bucket_iam_bindings = length(var.iam_members) > 0 ? {
    main_access = {
      bucket  = "main"
      role    = var.iam_role
      members = var.iam_members
    }
  } : {}
}
