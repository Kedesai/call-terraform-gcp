# -----------------------------------------------------------------------------
# Allocated Range Outputs
#
# These outputs form the downstream contract used by services such as
# Cloud SQL.
# -----------------------------------------------------------------------------

output "allocated_ip_range_id" {
  description = "Resource ID of the allocated Private Service Access range."
  value       = module.private_service_access.allocated_ip_range_id
}

output "allocated_ip_range_name" {
  description = "Name of the allocated Private Service Access range."
  value       = module.private_service_access.allocated_ip_range_name
}

output "allocated_ip_range_address" {
  description = "Starting address of the allocated Private Service Access range."
  value       = module.private_service_access.allocated_ip_range_address
}

output "allocated_ip_range_prefix_length" {
  description = "Prefix length of the allocated Private Service Access range."
  value       = module.private_service_access.allocated_ip_range_prefix_length
}

output "allocated_ip_range_self_link" {
  description = "Self-link of the allocated Private Service Access range."
  value       = module.private_service_access.allocated_ip_range_self_link
}


# -----------------------------------------------------------------------------
# Service Networking Connection Outputs
# -----------------------------------------------------------------------------

output "connection_network" {
  description = "VPC network used by the Service Networking connection."
  value       = module.private_service_access.connection_network
}

output "connection_service" {
  description = "Service producer connected through Private Service Access."
  value       = module.private_service_access.connection_service
}

output "connection_peering" {
  description = "Name of the VPC peering created by Service Networking."
  value       = module.private_service_access.connection_peering
}

output "reserved_peering_ranges" {
  description = "Allocated range names used by the connection."
  value       = module.private_service_access.reserved_peering_ranges
}
