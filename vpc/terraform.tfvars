project_id = "my-gcp-project"
region     = "us-central1"

network_name = "dev-vpc"

subnet_name = "dev-gke-subnet"
subnet_cidr = "10.10.0.0/20"

gke_pods_range_name = "gke-pods"
gke_pods_cidr       = "10.20.0.0/16"

gke_services_range_name = "gke-services"
gke_services_cidr       = "10.30.0.0/20"

private_ip_google_access = true

enable_flow_logs = true
