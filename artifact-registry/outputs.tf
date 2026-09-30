# -----------------------------------------------------------------------------
# Artifact Registry Outputs
#
# The reusable module returns maps because it supports multiple repositories.
#
# This caller manages one logical repository named "main", so these outputs
# expose simple values to downstream callers and HCP Terraform.
# -----------------------------------------------------------------------------

output "repository_id" {
  description = "Artifact Registry repository ID."
  value       = module.artifact_registry.repository_ids["main"]
}

output "repository_name" {
  description = "Artifact Registry repository resource name."
  value       = module.artifact_registry.repository_names["main"]
}

output "repository_location" {
  description = "Artifact Registry repository location."
  value       = module.artifact_registry.repository_locations["main"]
}


# -----------------------------------------------------------------------------
# Repository IAM Output
#
# Contains only IAM memberships managed by this deployment.
#
# The output is empty when iam_members is empty.
# -----------------------------------------------------------------------------

output "repository_iam_members" {
  description = "Repository-level IAM memberships managed by this deployment."
  value       = module.artifact_registry.repository_iam_members
}
