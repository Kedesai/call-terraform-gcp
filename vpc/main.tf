module "vpc" {
  source = "git::https://github.com/Kedesai/terraform.git//gcp/vpc"

  project_id = var.project_id

  create_vpc   = true
  network_name = var.network_name
  routing_mode = var.routing_mode

  create_subnets = true

  subnets = {
    gke = {
      name          = var.subnet_name
      region        = var.region
      ip_cidr_range = var.subnet_cidr

      private_ip_google_access = var.private_ip_google_access

      secondary_ip_ranges = {
        pods = {
          range_name    = var.gke_pods_range_name
          ip_cidr_range = var.gke_pods_cidr
        }

        services = {
          range_name    = var.gke_services_range_name
          ip_cidr_range = var.gke_services_cidr
        }
      }

      log_config = var.enable_flow_logs ? {
        aggregation_interval = "INTERVAL_5_SEC"
        flow_sampling        = 0.5
        metadata             = "INCLUDE_ALL_METADATA"
      } : null
    }
  }
}
