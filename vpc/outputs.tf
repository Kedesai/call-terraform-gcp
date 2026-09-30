output "network_id" {
  description = "VPC network ID."
  value       = module.vpc.network_id
}

output "network_name" {
  description = "VPC network name."
  value       = module.vpc.network_name
}

output "network_self_link" {
  description = "VPC network self-link."
  value       = module.vpc.network_self_link
}

output "subnet_ids" {
  description = "Created subnet IDs."
  value       = module.vpc.subnet_ids
}

output "subnet_names" {
  description = "Created subnet names."
  value       = module.vpc.subnet_names
}

output "subnet_self_links" {
  description = "Created subnet self-links."
  value       = module.vpc.subnet_self_links
}

output "subnet_cidr_ranges" {
  description = "Primary subnet CIDR ranges."
  value       = module.vpc.subnet_cidr_ranges
}

output "subnet_secondary_ranges" {
  description = "Subnet secondary ranges."
  value       = module.vpc.subnet_secondary_ranges
}
