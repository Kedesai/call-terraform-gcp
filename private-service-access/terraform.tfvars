# -----------------------------------------------------------------------------
# Private Service Access Deployment Variables
#
# These values should normally be supplied through HCP Terraform.
#
# Required:
#
# project_id = "my-gcp-project"
#
# hcp_organization   = "my-hcp-organization"
# vpc_workspace_name = "gcp-vpc"
#
# allocated_range_name = "google-managed-services-platform"
#
#
# -----------------------------------------------------------------------------
# Optional Explicit Address Allocation
# -----------------------------------------------------------------------------
#
# address       = "10.240.0.0"
# prefix_length = 16
#
# When address is null, Google selects an available range using prefix_length.
#
#
# -----------------------------------------------------------------------------
# Protection
# -----------------------------------------------------------------------------
#
# deletion_policy = "PREVENT"
#
#
# -----------------------------------------------------------------------------
# Custom Routes
# -----------------------------------------------------------------------------
#
# import_custom_routes = false
# export_custom_routes = false
# -----------------------------------------------------------------------------
