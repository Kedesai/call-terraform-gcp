GCP GKE Caller with HCP Terraform Outputs
Terraform caller configuration for deploying a GKE cluster using foundation outputs retrieved from upstream HCP Terraform workspaces.

Architecture
VPC workspace
    |
    +-- network_self_link
    +-- subnet_self_links["gke"]
                |
                | tfe_outputs
                v
Service Account workspace ---> GKE caller <--- KMS workspace
    |                            |                 |
    +-- service_account_email    |                 +-- crypto_key_id
                                 |
                                 v
                       Reusable GKE module
                                 |
                                 v
                         GKE cluster and
                       managed node pools
Directory Structure
gke/
├── versions.tf
├── variables.tf
├── data.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
Why tfe_outputs
The caller uses tfe_outputs to retrieve root outputs from upstream HCP Terraform workspaces.

This keeps:

GCP implementation in reusable modules
HCP dependency orchestration in caller modules
Foundation resources independent from workload resources
Network identifiers out of manually maintained workspace variables
Required Upstream Networking Outputs
The VPC workspace must expose:

output "network_self_link" {
  value = module.vpc.network_self_link
}

output "subnet_self_links" {
  value = module.vpc.subnet_self_links
}
The GKE caller selects its subnet with:

network_subnet_key = "gke"
The resulting lookup is:

data.tfe_outputs.network
  .nonsensitive_values
  .subnet_self_links["gke"]
Required HCP Variables
project_id
hcp_organization
network_workspace_name
cluster_name
Defaults provide:

hcp_hostname    = "app.terraform.io"
cluster_location = "us-central1"
network_subnet_key = "gke"

cluster_secondary_range_name  = "gke-pods"
services_secondary_range_name = "gke-services"
Optional Service Account Workspace
Enable service-account output consumption:

use_service_account_workspace  = true
service_account_workspace_name = "gcp-service-account"
The upstream workspace must expose:

output "service_account_email" {
  value = module.service_account.email
}
Optional KMS Workspace
Enable KMS output consumption:

use_kms_workspace  = true
kms_workspace_name = "gcp-kms"
The upstream workspace must expose:

output "crypto_key_id" {
  value = module.kms.crypto_key_ids["main"]
}
The key is passed to the reusable module for GKE database encryption.

Required KMS IAM authorization remains outside the GKE module.

HCP Terraform Output Access
The GKE workspace must be allowed to retrieve outputs from each upstream workspace it consumes.

Configure output/state-sharing access for:

VPC workspace            -> GKE workspace
Service Account workspace -> GKE workspace
KMS workspace             -> GKE workspace
If access is not granted, the tfe_outputs data source cannot retrieve the upstream values.

Run Triggers
tfe_outputs passes data between workspaces.

A run trigger can separately start a downstream GKE run after a successful upstream apply.

VPC apply
   |
   +-- updated outputs
   |
   +-- run trigger
           |
           v
       GKE run
           |
           +-- reads current VPC outputs
Output sharing and run triggers serve different purposes:

tfe_outputs  -> passes data
run trigger  -> starts execution
VPC Secondary Range Contract
The GKE caller defaults to:

cluster_secondary_range_name  = "gke-pods"
services_secondary_range_name = "gke-services"
These names must match secondary ranges already configured on the selected foundation subnet.

Private Cluster Defaults
enable_private_nodes         = true
enable_private_endpoint      = false
master_ipv4_cidr_block       = "172.16.0.0/28"
master_global_access_enabled = false
Cloud Router and Cloud NAT remain separate foundation capabilities.

System Node Pool
This caller creates one logical node pool:

node_pools = {
  system = {
    ...
  }
}
The caller exposes simple HCP variables while the reusable module retains its multi-node-pool interface.

HCP Workspace
Suggested workspace:

gcp-gke
Repository:

Kedesai/call-gcp-terraform
Working directory:

gke
Recommended settings:

Auto apply: Disabled
Speculative plans: Enabled
Outputs
The caller exposes:

cluster_id
cluster_name
cluster_location
cluster_self_link
cluster_endpoint
cluster_ca_certificate
network
subnetwork
cluster_secondary_range_name
services_secondary_range_name
workload_identity_pool
node_pool_id
node_pool_name
node_pool_instance_group_urls
Control-plane endpoint and CA certificate outputs are marked sensitive.

Validation
terraform fmt -recursive
terraform init
terraform validate
terraform plan
Design Principles
Foundation networking is created outside GKE
Network outputs are retrieved through tfe_outputs
Node service accounts are created outside GKE
KMS keys are created outside GKE
HCP workspace logic remains in the caller
The reusable GKE module remains HCP-independent
Private nodes are enabled by default
Workload Identity Federation is enabled by default
Deletion protection is enabled by default
Run triggers and output sharing remain separate mechanisms

HCP dependency setup

The intended workspace connections are:

gcp-vpc
   ├── Permit output access to gcp-gke
   └── Optional run trigger to gcp-gke

gcp-service-account
   ├── Permit output access to gcp-gke
   └── Optional run trigger to gcp-gke

gcp-kms
   ├── Permit output access to gcp-gke
   └── Optional run trigger to gcp-gke