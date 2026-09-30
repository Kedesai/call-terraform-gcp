GCP Cloud SQL Caller
Terraform caller for deploying Google Cloud SQL using the reusable Cloud SQL module.

Architecture
Networking Foundation
       |
       +-- VPC
       |
       +-- Private Service Access range
       |
       +-- Service Networking connection
                |
                v
        Cloud SQL Caller
                |
                +---- optional KMS workspace
                |
                v
      Reusable Cloud SQL Module
             |       |
             v       v
         Instance  Databases
Repositories
Reusable module:

Kedesai/terraform/gcp/cloud-sql
Caller:

Kedesai/call-gcp-terraform/cloud-sql
Caller Structure
cloud-sql/
├── versions.tf
├── variables.tf
├── data.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
HCP Terraform Workspace
Suggested workspace:

gcp-cloud-sql
Repository:

Kedesai/call-gcp-terraform
Working directory:

cloud-sql
Basic PostgreSQL Configuration
project_id = "my-gcp-project"
region     = "us-central1"

instance_name    = "platform-postgres"
database_version = "POSTGRES_15"
tier             = "db-custom-2-7680"

private_network = "projects/my-gcp-project/global/networks/platform-vpc"

databases = {
  application = {
    name = "application"
  }
}
Private Networking
This caller assumes the networking foundation already exists.

VPC
 |
 v
Private Service Access
 |
 v
Service Networking Connection
 |
 v
Cloud SQL
The caller currently accepts:

private_network
allocated_ip_range
directly.

Once the reusable Private Service Access module and HCP workspace contract are created, these inputs can be sourced from upstream HCP Terraform outputs.

Public Connectivity
Public IPv4 is disabled by default:

ipv4_enabled = false
The normal platform deployment should use private connectivity.

KMS
Optional CMEK integration uses an upstream HCP Terraform workspace.

hcp_organization   = "my-organization"
use_kms_workspace  = true
kms_workspace_name = "gcp-kms"
The upstream KMS workspace must expose:

crypto_key_id
The caller passes that key to the reusable Cloud SQL module.

Backups
Default configuration:

backup_enabled    = true
backup_start_time = "03:00"
retained_backups  = 7
Point-in-Time Recovery
The caller passes the PITR configuration to the reusable Cloud SQL module.

The reusable module is responsible for applying engine-specific behavior.

Multiple Databases
databases = {
  application = {
    name = "application"
  }

  reporting = {
    name = "reporting"
  }
}
Database Credentials
Database credentials are intentionally not managed by this caller.

No username variable
No password variable
No password output
Database identity and Secret Manager integration remain separate concerns.

Deletion Protection
Enabled by default:

deletion_protection = true
Before intentionally destroying an instance:

deletion_protection = false
Apply the configuration change before destroying the Cloud SQL instance.

Outputs
The workspace exposes:

instance_id
instance_name
connection_name
database_version
region
private_ip_address
public_ip_address
database_ids
database_names
These outputs can later be consumed by other HCP Terraform workspaces when a real dependency exists.

IAM
IAM is intentionally not implemented here.

IAM will be addressed after completion of the reusable service modules as part of the IAM and GCP Landing Zone design.

API Enablement
API enablement is intentionally outside the service caller.

The future project/foundation layer should own required Google Cloud API enablement.

Design Principles
Resource implementation stays in the reusable module
Environment configuration stays in the caller
Private networking is preferred
Private Service Access stays in the networking layer
KMS keys are consumed rather than recreated
IAM stays outside the caller
API enablement stays outside the caller
Database credentials stay outside Terraform service composition
HCP workspace dependencies are introduced only when required