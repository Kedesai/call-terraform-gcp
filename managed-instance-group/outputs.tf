# -----------------------------------------------------------------------------
# Managed Instance Group Outputs
# -----------------------------------------------------------------------------

output "instance_group_manager_id" {
  description = "Regional Managed Instance Group manager resource ID."
  value       = module.managed_instance_group.instance_group_manager_id
}

output "instance_group_manager_name" {
  description = "Regional Managed Instance Group manager name."
  value       = module.managed_instance_group.instance_group_manager_name
}

output "instance_group_manager_self_link" {
  description = "Regional Managed Instance Group manager self-link."
  value       = module.managed_instance_group.instance_group_manager_self_link
}

output "instance_group" {
  description = "Underlying instance-group reference for downstream load-balancing services."
  value       = module.managed_instance_group.instance_group
}

output "region" {
  description = "Region containing the Managed Instance Group."
  value       = module.managed_instance_group.region
}

output "target_size" {
  description = "Managed Instance Group target size reported by the reusable module."
  value       = module.managed_instance_group.target_size
}


# -----------------------------------------------------------------------------
# Autoscaler Outputs
# -----------------------------------------------------------------------------

output "autoscaler_id" {
  description = "Regional autoscaler resource ID, or null when autoscaling is disabled."
  value       = module.managed_instance_group.autoscaler_id
}

output "autoscaler_name" {
  description = "Regional autoscaler name, or null when autoscaling is disabled."
  value       = module.managed_instance_group.autoscaler_name
}

output "autoscaler_self_link" {
  description = "Regional autoscaler self-link, or null when autoscaling is disabled."
  value       = module.managed_instance_group.autoscaler_self_link
}
