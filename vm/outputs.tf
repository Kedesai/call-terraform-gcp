# -----------------------------------------------------------------------------
# VM Identity Outputs
#
# The reusable module returns maps because it supports multiple VMs.
#
# This caller manages one logical VM named "main", so these outputs expose
# simple scalar values.
# -----------------------------------------------------------------------------

output "instance_id" {
  description = "Compute Engine VM instance ID."
  value       = module.vm.instance_ids["main"]
}

output "instance_name" {
  description = "Compute Engine VM instance name."
  value       = module.vm.instance_names["main"]
}

output "instance_self_link" {
  description = "Compute Engine VM instance self-link."
  value       = module.vm.instance_self_links["main"]
}

output "instance_zone" {
  description = "Compute Engine VM instance zone."
  value       = module.vm.instance_zones["main"]
}

# -----------------------------------------------------------------------------
# VM Network Outputs
# -----------------------------------------------------------------------------

output "internal_ip_address" {
  description = "Internal IPv4 address assigned to the VM."
  value       = module.vm.internal_ip_addresses["main"]
}

output "external_ip_address" {
  description = "External IPv4 address assigned to the VM, or null when absent."
  value       = module.vm.external_ip_addresses["main"]
}

# -----------------------------------------------------------------------------
# Boot Disk Output
# -----------------------------------------------------------------------------

output "boot_disk_source" {
  description = "Boot disk source reference for the VM."
  value       = module.vm.boot_disk_sources["main"]
}
