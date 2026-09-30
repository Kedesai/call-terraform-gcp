# -----------------------------------------------------------------------------
# GKE Cluster Outputs
#
# These outputs expose the reusable GKE module's cluster-level values.
# -----------------------------------------------------------------------------

output "cluster_id" {
  description = "GKE cluster resource ID."
  value       = module.gke.cluster_id
}

output "cluster_name" {
  description = "GKE cluster name."
  value       = module.gke.cluster_name
}

output "cluster_location" {
  description = "GKE cluster region or zone."
  value       = module.gke.cluster_location
}

output "cluster_self_link" {
  description = "GKE cluster self-link."
  value       = module.gke.cluster_self_link
}


# -----------------------------------------------------------------------------
# Sensitive Control-Plane Outputs
#
# Sensitive marking prevents normal display but does not remove the values
# from Terraform state.
# -----------------------------------------------------------------------------

output "cluster_endpoint" {
  description = "GKE control-plane endpoint."
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64-encoded GKE cluster CA certificate."
  value       = module.gke.cluster_ca_certificate
  sensitive   = true
}


# -----------------------------------------------------------------------------
# Network Outputs
#
# These values confirm which upstream foundation network resources were used.
# -----------------------------------------------------------------------------

output "network" {
  description = "Foundation VPC network used by the GKE cluster."
  value       = module.gke.network
}

output "subnetwork" {
  description = "Foundation subnet used by the GKE cluster."
  value       = module.gke.subnetwork
}

output "cluster_secondary_range_name" {
  description = "Secondary range used for GKE Pods."
  value       = module.gke.cluster_secondary_range_name
}

output "services_secondary_range_name" {
  description = "Secondary range used for Kubernetes Services."
  value       = module.gke.services_secondary_range_name
}


# -----------------------------------------------------------------------------
# Workload Identity Output
# -----------------------------------------------------------------------------

output "workload_identity_pool" {
  description = "Workload Identity Federation pool used by GKE."
  value       = module.gke.workload_identity_pool
}


# -----------------------------------------------------------------------------
# Node Pool Outputs
# -----------------------------------------------------------------------------

output "node_pool_id" {
  description = "System node-pool resource ID."
  value       = module.gke.node_pool_ids["system"]
}

output "node_pool_name" {
  description = "System node-pool name."
  value       = module.gke.node_pool_names["system"]
}

output "node_pool_instance_group_urls" {
  description = "Instance-group URLs created for the system node pool."
  value       = module.gke.node_pool_instance_group_urls["system"]
}
