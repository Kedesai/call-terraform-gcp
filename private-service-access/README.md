GCP Private Service Access Caller
Terraform caller for creating Private Service Access by consuming an existing VPC from an upstream HCP Terraform workspace.

Architecture
VPC Workspace
     |
     +-- network_id
     +-- network_name
              |
              | tfe_outputs
              v
Private Service Access Caller
              |
              v
Reusable PSA Module
     |
     +-- Allocated peering range
     +-- Service Networking connection
     +-- Optional route exchange
              |
              v
Cloud SQL and other supported services
Repository Structure
Reusable module:

Kedesai/terraform/gcp/private-service-access
Caller:

Kedesai/call-gcp-terraform/private-service-access
Caller files:

private-service-access/
├── versions.tf
├── variables.tf
├── data.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
No locals.tf is currently required.

Required Upstream VPC Outputs
The upstream VPC workspace must expose:

output "network_id" {
  description = "VPC network resource ID."
  value       = module.vpc.network_id
}

output "network_name" {
  description = "VPC network name."
  value       = module.vpc.network_name
}
The output names must match the caller references exactly:

data.tfe_outputs.vpc.nonsensitive_values.network_id

data.tfe_outputs.vpc.nonsensitive_values.network_name
HCP Terraform Workspace
Suggested workspace:

gcp-private-service-access
Repository:

Kedesai/call-gcp-terraform
Working directory:

private-service-access
Recommended settings:

Auto apply: Disabled
Speculative plans: Enabled
Required Variables
project_id = "my-gcp-project"

hcp_organization   = "my-hcp-organization"
vpc_workspace_name = "gcp-vpc"

allocated_range_name = "google-managed-services-platform"
HCP Output Sharing
The VPC workspace must allow the PSA workspace to retrieve its outputs:

gcp-vpc
    |
    +-- network outputs
            |
            v
gcp-private-service-access
The PSA caller retrieves those values using tfe_outputs.

Optional Run Trigger
A run trigger can be configured separately:

VPC apply
    |
    +-- outputs updated
    |
    +-- run trigger
            |
            v
PSA run
The responsibilities stay separate:

tfe_outputs  -> passes dependency data

run trigger  -> controls execution sequencing
Automatic Range Allocation
address       = null
prefix_length = 16
Google Cloud selects the address range.

The resulting allocation must not overlap existing or planned network ranges.

Explicit Range Allocation
address       = "10.240.0.0"
prefix_length = 16
The explicit range should not overlap:

Existing subnet ranges
Planned subnet ranges
Connected VPC ranges
Existing allocated service ranges
Service Producer
Default:

service = "servicenetworking.googleapis.com"
Connection Protection
The caller inherits the reusable module's protected default:

deletion_policy = "PREVENT"
Supported values are:

PREVENT
ABANDON
DELETE
PREVENT
Prevents Terraform from deleting the Service Networking connection.

ABANDON
Removes the connection from Terraform management without deleting the underlying connection through the API.

DELETE
Allows Terraform to request deletion of the Service Networking connection.

Dependent managed services should be removed before using this option.

Safe Teardown Process
1. Remove dependent Cloud SQL and other managed-service resources
2. Confirm no service still depends on the PSA connection
3. Change deletion_policy from PREVENT to DELETE
4. Apply the changed deletion policy
5. Remove the PSA caller configuration
6. Apply or destroy the workspace
If the connection should remain but Terraform should stop managing it:

deletion_policy = "ABANDON"
Existing Connection Update
Optional:

update_on_creation_fail = true
Enable this only when an existing Service Networking connection is expected and updating its reserved ranges is intentional.

Custom Route Exchange
Disabled by default:

import_custom_routes = false
export_custom_routes = false
Enable only when custom routes must be exchanged across the service peering.

Downstream Cloud SQL Contract
The PSA caller exposes the values required for the Cloud SQL dependency:

allocated_ip_range_name
connection_network
connection_peering
The Cloud SQL caller can consume:

private_network = (
  data.tfe_outputs.psa
  .nonsensitive_values
  .connection_network
)

allocated_ip_range = (
  data.tfe_outputs.psa
  .nonsensitive_values
  .allocated_ip_range_name
)
The resulting workspace dependency model is:

VPC Workspace
     |
     | network_id
     | network_name
     v
PSA Workspace
     |
     | connection_network
     | allocated_ip_range_name
     v
Cloud SQL Workspace
API Enablement
The project or foundation layer must enable:

servicenetworking.googleapis.com
API enablement intentionally remains outside this service caller.

Shared VPC
For a Shared VPC architecture, project_id should identify the project that owns the VPC and Private Service Access resources.

Conceptually:

Shared VPC Host Project
├── VPC
└── Private Service Access

Service Project
└── Cloud SQL
The landing-zone layer can later make this relationship explicit.

Outputs
The caller exposes:

allocated_ip_range_id
allocated_ip_range_name
allocated_ip_range_address
allocated_ip_range_prefix_length
allocated_ip_range_self_link
connection_network
connection_service
connection_peering
reserved_peering_ranges
Validation
Before committing or running through HCP Terraform:

terraform fmt -recursive
terraform init
terraform validate
terraform plan
Design Principles
VPC creation remains independent
PSA remains a shared network-foundation capability
Managed services consume PSA instead of recreating it
HCP dependency wiring remains in the caller
API enablement remains in the foundation layer
IAM remains separate
Destructive connection deletion is protected by default
Shared VPC ownership remains distinguishable from service-project ownership