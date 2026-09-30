# project_id       = "my-gcp-project"
# hcp_organization = "my-hcp-organization"
# mig_workspace_name = "gcp-managed-instance-group"

# name = "application"

backend_protocol = "HTTP"

port_name   = "http"
timeout_sec = 30

enable_cdn = false

balancing_mode  = "UTILIZATION"
capacity_scaler = 1.0
max_utilization = 0.8

health_check_port         = 8080
health_check_request_path = "/"

health_check_interval_sec = 10
health_check_timeout_sec  = 5

healthy_threshold   = 2
unhealthy_threshold = 3

enable_logging  = true
log_sample_rate = 1.0
