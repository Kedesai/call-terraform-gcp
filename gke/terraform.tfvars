# -----------------------------------------------------------------------------
# Environment-Specific Terraform Variables
#
# Environment-specific values are intentionally not committed to this
# repository.
#
# Supply them through HCP Terraform workspace or project variable sets.
#
# Required:
#
# project_id             = "my-gcp-project"
# hcp_organization       = "my-hcp-organization"
# network_workspace_name = "gcp-vpc"
# cluster_name           = "platform-gke"
#
# The VPC workspace is expected to expose:
#
# network_self_link
# subnet_self_links
#
# The default subnet selector is:
#
# network_subnet_key = "gke"
#
# Optional Service Account workspace:
#
# use_service_account_workspace  = true
# service_account_workspace_name = "gcp-service-account"
#
# The Service Account workspace must expose:
#
# service_account_email
#
# Optional KMS workspace:
#
# use_kms_workspace = true
# kms_workspace_name = "gcp-kms"
#
# The KMS workspace must expose:
#
# crypto_key_id
#
# GKE range names must match the VPC subnet secondary range names:
#
# cluster_secondary_range_name  = "gke-pods"
# services_secondary_range_name = "gke-services"
#
# Optional node-pool overrides:
#
# node_machine_type = "e2-standard-4"
# node_min_count    = 1
# node_max_count    = 3
#
# resource_labels = {
#   managed_by  = "terraform"
#   environment = "dev"
#   platform    = "gke"
# }
# -----------------------------------------------------------------------------
