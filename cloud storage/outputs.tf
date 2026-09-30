# -----------------------------------------------------------------------------
# Cloud Storage Outputs
#
# The reusable module returns maps because it can manage multiple buckets.
#
# This caller manages a single logical bucket named "main", so these outputs
# expose simple scalar values for downstream consumers.
# -----------------------------------------------------------------------------

output "bucket_name" {
  description = "Name of the Cloud Storage bucket."
  value       = module.cloud_storage.bucket_names["main"]
}

output "bucket_id" {
  description = "ID of the Cloud Storage bucket."
  value       = module.cloud_storage.bucket_ids["main"]
}

output "bucket_url" {
  description = "URL of the Cloud Storage bucket."
  value       = module.cloud_storage.bucket_urls["main"]
}

output "bucket_self_link" {
  description = "Self-link of the Cloud Storage bucket."
  value       = module.cloud_storage.bucket_self_links["main"]
}


# -----------------------------------------------------------------------------
# Bucket IAM Output
#
# This output contains only IAM memberships managed by this Terraform caller.
#
# It will be empty when no iam_members are supplied.
# -----------------------------------------------------------------------------

output "bucket_iam_members" {
  description = "Bucket-level IAM memberships managed by this deployment."
  value       = module.cloud_storage.bucket_iam_members
}
