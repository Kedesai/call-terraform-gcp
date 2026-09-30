module "service_account" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/service-account"

  project_id = var.project_id

  create_service_account = var.create_service_account

  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description

  existing_service_account_email = var.existing_service_account_email

  project_roles = var.project_roles
}
