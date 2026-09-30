GCP External HTTP Load Balancer Caller
Terraform caller for deploying a global external HTTP Application Load Balancer using the reusable load-balancer module and a Managed Instance Group retrieved from an upstream HCP Terraform workspace.

Architecture
MIG Workspace
     |
     | instance_group
     v
Load Balancer Caller
     |
     v
Reusable Load Balancer
     |
     +-- Global IP
     +-- Health Check
     +-- Backend Service
     +-- URL Map
     +-- HTTP Proxy
     +-- Forwarding Rule
Upstream MIG Contract
The MIG workspace must expose:

output "instance_group" {
  value = module.managed_instance_group.instance_group
}
HCP Terraform Workspace
Suggested workspace:

gcp-load-balancer
Working directory:

load-balancer
Required Variables
project_id = "my-gcp-project"

hcp_organization = "my-hcp-organization"
mig_workspace_name = "gcp-managed-instance-group"

name = "application"
Backend Port
The load-balancer port name must match the MIG named port.

MIG:

named_ports = {
  http = 8080
}
Load balancer:

port_name = "http"
health_check_port = 8080
Autoscaling
MIG autoscaling remains managed by the MIG workspace.

The load-balancer caller only consumes the resulting instance group.

Validation
terraform fmt -recursive
terraform init
terraform validate
terraform plan