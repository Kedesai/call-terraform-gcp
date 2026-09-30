GCP Compute Engine VM Caller
Terraform caller configuration for deploying one Google Compute Engine VM using the reusable GCP VM module.

Architecture
VPC caller
    |
    +-- subnetwork_self_link
                |
                v
Service Account caller ---> VM caller <--- KMS caller
    |                         |               |
    +-- email                 |               +-- crypto_key_id
                              |
                              v
                    Reusable VM module
                              |
                              v
                    Compute Engine VM
Repository Responsibilities
Reusable implementation:

Kedesai/terraform/gcp/vm
Environment-specific caller:

Kedesai/call-gcp-terraform/vm
Required Variables
A basic VM requires:

project_id           = "my-gcp-project"
instance_name        = "application-vm"
subnetwork_self_link = "projects/.../regions/.../subnetworks/..."
Safe Defaults
The caller defaults to:

deletion_protection       = true
allow_stopping_for_update = true
can_ip_forward            = false
assign_external_ip        = false

enable_secure_boot          = false
enable_vtpm                 = true
enable_integrity_monitoring = true
Deletion protection must be disabled before Terraform can destroy the VM.

VM Update Behavior
The caller enables:

allow_stopping_for_update = true
This permits Terraform to stop the VM when a requested update cannot be performed while the instance is running.

Private Networking
The VM does not receive an external IP by default:

assign_external_ip = false
An external IP must be enabled explicitly:

assign_external_ip = true
network_tier       = "PREMIUM"
Service Account
A custom service account can be supplied with:

service_account_email = "application-sa@my-project.iam.gserviceaccount.com"
Default scopes are:

[
  "cloud-platform"
]
IAM permissions should be assigned independently to the service account.

CMEK
The caller uses the common platform input:

kms_key_id
KMS caller
    |
    +-- crypto_key_id
              |
              v
VM caller
    |
    +-- kms_key_id
              |
              v
VM boot disk
The appropriate Google service identity must have permission to use the Crypto Key.

Standard VM Scheduling
provisioning_model  = "STANDARD"
automatic_restart   = true
on_host_maintenance = "MIGRATE"
preemptible         = false
Spot VM Scheduling
provisioning_model  = "SPOT"
automatic_restart   = false
on_host_maintenance = "TERMINATE"
preemptible         = false
Caller validation rejects a Spot configuration that does not disable automatic restart and use TERMINATE for host maintenance.

HCP Terraform
Suggested workspace:

gcp-vm
Repository:

Kedesai/call-gcp-terraform
Working directory:

vm
Core Terraform variables:

project_id
instance_name
subnetwork_self_link
Optional values only need to be configured when overriding defaults or enabling optional capabilities.

Outputs
The caller exposes:

instance_id
instance_name
instance_self_link
instance_zone
internal_ip_address
external_ip_address
boot_disk_source
Validation
Before committing:

terraform fmt -recursive
terraform init
terraform validate
terraform plan
Design Principles
VM implementation remains in the reusable module
Deployment configuration remains in the caller
Provider configuration remains in versions.tf
Authentication remains outside source control
Networking is consumed rather than recreated
Service accounts are consumed rather than recreated
KMS keys are consumed rather than recreated
Private networking is the default
Public IP assignment is explicit
Deletion protection is enabled by default
VM updates may stop the instance when required
Secret values do not belong in metadata or startup scripts