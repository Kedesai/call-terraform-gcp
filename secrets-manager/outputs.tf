# -----------------------------------------------------------------------------
# Secret Manager Outputs
#
# The reusable module returns maps because it supports multiple secrets.
#
# This caller manages one logical secret named "main", so the outputs expose
# simple values rather than requiring downstream users to understand the map.
# -----------------------------------------------------------------------------

output "secret_id" {
  description = "Secret Manager secret ID."
  value       = module.secret_manager.secret_ids["main"]
}

output "secret_name" {
  description = "Fully qualified Secret Manager resource name."
  value       = module.secret_manager.secret_names["main"]
}

# -----------------------------------------------------------------------------
# Replication Output
#
# Exposes the replication configuration returned by the reusable module.
# No secret payload or secret-version value is exposed.
# -----------------------------------------------------------------------------

output "secret_replication" {
  description = "Replication configuration for the Secret Manager secret."
  value       = module.secret_manager.secret_replication["main"]
}

# -----------------------------------------------------------------------------
# IAM Output
#
# Exposes secret-level IAM assignments created through this caller.
# The map will be empty when no IAM members were provided.
# -----------------------------------------------------------------------------

output "secret_iam_members" {
  description = "Secret-level IAM memberships created for this secret."
  value       = module.secret_manager.secret_iam_members
}
