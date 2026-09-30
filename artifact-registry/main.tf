# -----------------------------------------------------------------------------
# Reusable GCP Artifact Registry Module
#
# This caller consumes the reusable Artifact Registry module maintained in:
#
#   Kedesai/terraform/gcp/artifact-registry
#
# The reusable module contains the Artifact Registry resource implementation.
#
# This caller provides a simpler one-repository-per-workspace interface suited
# to HCP Terraform.
# -----------------------------------------------------------------------------

module "artifact_registry" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/artifact-registry"

  # ---------------------------------------------------------------------------
  # GCP Project
  # ---------------------------------------------------------------------------

  project_id = var.project_id


  # ---------------------------------------------------------------------------
  # Repository Definition
  #
  # The reusable module supports multiple repositories through a map.
  #
  # This caller manages one logical repository named "main".
  #
  # "main" is only the Terraform map key. The actual Artifact Registry
  # repository name is controlled by var.repository_id.
  # ---------------------------------------------------------------------------

  repositories = {
    main = {

      # -----------------------------------------------------------------------
      # Basic Repository Configuration
      # -----------------------------------------------------------------------

      repository_id = var.repository_id
      location      = var.repository_location
      format        = var.repository_format
      description   = var.description


      # -----------------------------------------------------------------------
      # Docker Repository Configuration
      #
      # The reusable module creates docker_config only when format = DOCKER.
      #
      # For other repository formats this value is harmless because the
      # reusable module does not generate the Docker-specific configuration.
      # -----------------------------------------------------------------------

      immutable_tags = var.immutable_tags


      # -----------------------------------------------------------------------
      # Customer-Managed Encryption Key
      #
      # Our caller interface uses kms_key_id.
      #
      # The reusable module uses kms_key_name because that matches the
      # underlying Artifact Registry resource configuration.
      #
      # When kms_key_id is null, no CMEK is configured by this caller.
      # -----------------------------------------------------------------------

      kms_key_name = var.kms_key_id


      # -----------------------------------------------------------------------
      # Resource Labels
      # -----------------------------------------------------------------------

      labels = var.labels
    }
  }


  # ---------------------------------------------------------------------------
  # Repository-Level IAM
  #
  # IAM configuration is optional.
  #
  # When iam_members is empty:
  #
  #   repository_iam_bindings = {}
  #
  # and the reusable module creates no repository IAM member resources.
  #
  # When identities are supplied, the caller creates one logical binding named
  # "main_access".
  #
  # repository = "main" references the logical repository key above rather
  # than repeating the actual Artifact Registry repository ID.
  # ---------------------------------------------------------------------------

  repository_iam_bindings = length(var.iam_members) > 0 ? {
    main_access = {
      repository = "main"
      role       = var.iam_role
      members    = var.iam_members
    }
  } : {}
}
