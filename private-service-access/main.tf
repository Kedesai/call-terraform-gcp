# -----------------------------------------------------------------------------
# Reusable Private Service Access Module
#
# The VPC network is retrieved from an upstream HCP Terraform workspace.
#
# Resource implementation remains in:
#
#   Kedesai/terraform/gcp/private-service-access
# -----------------------------------------------------------------------------

module "private_service_access" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/private-service-access"

  # ---------------------------------------------------------------------------
  # GCP Project
  # ---------------------------------------------------------------------------

  project_id = var.project_id


  # ---------------------------------------------------------------------------
  # Existing VPC
  #
  # The caller retrieves these outputs from the VPC workspace rather than
  # manually duplicating VPC identifiers.
  # ---------------------------------------------------------------------------

  network_id = (
    data.tfe_outputs.vpc
    .nonsensitive_values
    .network_id
  )

  network_name = (
    data.tfe_outputs.vpc
    .nonsensitive_values
    .network_name
  )


  # ---------------------------------------------------------------------------
  # Allocated Peering Range
  # ---------------------------------------------------------------------------

  allocated_range_name = (
    var.allocated_range_name
  )

  allocated_range_description = (
    var.allocated_range_description
  )

  address       = var.address
  prefix_length = var.prefix_length


  # ---------------------------------------------------------------------------
  # Service Networking Connection
  # ---------------------------------------------------------------------------

  service = var.service

  deletion_policy = (
    var.deletion_policy
  )

  update_on_creation_fail = (
    var.update_on_creation_fail
  )


  # ---------------------------------------------------------------------------
  # Optional Custom Route Exchange
  # ---------------------------------------------------------------------------

  import_custom_routes = (
    var.import_custom_routes
  )

  export_custom_routes = (
    var.export_custom_routes
  )
}
