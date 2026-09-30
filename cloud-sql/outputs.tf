# -----------------------------------------------------------------------------
# Cloud SQL Instance
# -----------------------------------------------------------------------------

output "instance_id" {
  description = "Cloud SQL instance resource ID."
  value       = module.cloud_sql.instance_id
}

output "instance_name" {
  description = "Cloud SQL instance name."
  value       = module.cloud_sql.instance_name
}

output "connection_name" {
  description = "Cloud SQL connection name."
  value       = module.cloud_sql.connection_name
}

output "database_version" {
  description = "Cloud SQL database engine/version."
  value       = module.cloud_sql.database_version
}

output "region" {
  description = "Cloud SQL instance region."
  value       = module.cloud_sql.region
}


# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

output "private_ip_address" {
  description = "Cloud SQL private IP address."
  value       = module.cloud_sql.private_ip_address
}

output "public_ip_address" {
  description = "Cloud SQL public IP address when enabled."
  value       = module.cloud_sql.public_ip_address
}


# -----------------------------------------------------------------------------
# Databases
# -----------------------------------------------------------------------------

output "database_ids" {
  description = "Map of Cloud SQL database resource IDs."
  value       = module.cloud_sql.database_ids
}

output "database_names" {
  description = "Map of Cloud SQL database names."
  value       = module.cloud_sql.database_names
}
