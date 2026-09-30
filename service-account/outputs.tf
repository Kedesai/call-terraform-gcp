output "service_account_email" {
  description = "Service account email."
  value       = module.service_account.email
}

output "service_account_name" {
  description = "Fully qualified service account resource name."
  value       = module.service_account.name
}

output "service_account_member" {
  description = "IAM member representation of the service account."
  value       = module.service_account.member
}

output "service_account_account_id" {
  description = "Created service account account ID."
  value       = module.service_account.account_id
}

output "service_account_unique_id" {
  description = "Created service account unique ID."
  value       = module.service_account.unique_id
}
