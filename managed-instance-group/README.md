GCP Regional Managed Instance Group Caller
Terraform caller for deploying a regional Managed Instance Group using an instance template retrieved from an upstream HCP Terraform workspace.

Architecture
Instance Template Workspace
          |
          +-- instance_template_self_link
                         |
                         v
Health Check Workspace -> MIG Caller
                         |
                         v
                 Reusable MIG Module
                         |
                  +------+------+
                  |             |
                  v             v
             Regional MIG   Autoscaler
                  |
                  v
           Load Balancer Backend
Required Upstream Output
The instance-template workspace must expose:

output "instance_template_self_link" {
  value = module.instance_template.self_link_unique
}
Optional Health-Check Output
output "health_check_id" {
  value = module.health_check.id
}
HCP Workspace
Workspace: gcp-managed-instance-group
Working directory: managed-instance-group
Required Variables
project_id       = "my-gcp-project"
hcp_organization = "my-hcp-organization"

instance_template_workspace_name = "gcp-instance-template"

name               = "application-mig"
base_instance_name = "application"
Autoscaling
enable_autoscaling     = true
min_replicas           = 2
max_replicas           = 5
cpu_utilization_target = 0.60
Autohealing
use_health_check_workspace = true
health_check_workspace_name = "gcp-health-check"
enable_autohealing          = true
Load Balancer Contract
The caller exposes:

instance_group
The load-balancer workspace can consume that output using tfe_outputs.

Validation
terraform fmt -recursive
terraform init
terraform validate
terraform plan