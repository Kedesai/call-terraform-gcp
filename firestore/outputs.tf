# -----------------------------------------------------------------------------
# Firestore Outputs
#
# Pass reusable-module outputs through the caller so they are available as HCP
# Terraform workspace outputs.
# -----------------------------------------------------------------------------

output "database_id" {
  description = "Firestore database resource ID."
  value       = module.firestore.database_id
}

output "database_name" {
  description = "Firestore database name."
  value       = module.firestore.database_name
}

output "location_id" {
  description = "Firestore database location."
  value       = module.firestore.location_id
}

output "database_type" {
  description = "Firestore database type."
  value       = module.firestore.database_type
}
