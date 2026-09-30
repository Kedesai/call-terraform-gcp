# -----------------------------------------------------------------------------
# GCP Managed Instance Group Caller
# -----------------------------------------------------------------------------

# project_id = "my-gcp-project"

region = "us-central1"


# -----------------------------------------------------------------------------
# HCP Terraform
# -----------------------------------------------------------------------------

# hcp_organization = "my-hcp-organization"

# instance_template_workspace_name = "gcp-instance-template"


# -----------------------------------------------------------------------------
# Managed Instance Group
# -----------------------------------------------------------------------------

# name               = "application-mig"
# base_instance_name = "application"

version_name = "primary"


# -----------------------------------------------------------------------------
# Regional Distribution
# -----------------------------------------------------------------------------

# distribution_policy_zones = [
#   "us-central1-a",
#   "us-central1-b"
# ]

distribution_policy_target_shape = "EVEN"


# -----------------------------------------------------------------------------
# Initial Size
# -----------------------------------------------------------------------------

target_size = 2


# -----------------------------------------------------------------------------
# Named Ports
# -----------------------------------------------------------------------------

named_ports = {
  http = 8080
}


# -----------------------------------------------------------------------------
# Autohealing
#
# Enable these settings after the health-check workspace exists.
# -----------------------------------------------------------------------------

enable_autohealing = false

# use_health_check_workspace  = true
# health_check_workspace_name = "gcp-health-check"

initial_delay_sec = 300


# -----------------------------------------------------------------------------
# Rolling Update
# -----------------------------------------------------------------------------

update_type                    = "PROACTIVE"
minimal_action                 = "REPLACE"
most_disruptive_allowed_action = "REPLACE"
replacement_method             = "SUBSTITUTE"

max_surge_fixed       = 1
max_unavailable_fixed = 0


# -----------------------------------------------------------------------------
# CPU Autoscaling
# -----------------------------------------------------------------------------

enable_autoscaling = true

min_replicas = 2
max_replicas = 5

cooldown_period_sec    = 60
cpu_utilization_target = 0.60
