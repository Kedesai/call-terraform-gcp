GCP Secret Manager Caller
Terraform caller configuration for deploying a Google Cloud Secret Manager secret using the reusable Secret Manager module maintained in the central Terraform module repository.

This caller provides a simplified interface designed for HCP Terraform workspaces. It translates simple workspace variables into the richer object structure expected by the reusable module.

Architecture
HCP Terraform workspace
          |
          | Simple workspace variables
          v
call-gcp-terraform/secret-manager
          |
          | Reusable module call
          v
terraform/gcp/secret-manager
          |
          +-- Secret container
          +-- Replication configuration
          +-- Optional CMEK
          +-- Optional secret-level IAM
Repository Responsibilities
Reusable module
The reusable implementation is maintained in:

Kedesai/terraform/gcp/secret-manager
The reusable module provides the general Secret Manager capabilities, including:

Multiple secrets
Automatic replication
User-managed replication
Optional customer-managed encryption keys
Optional IAM access
Reusable outputs
Caller module
This caller is maintained in:

Kedesai/call-gcp-terraform/secret-manager
The caller provides:

A simple one-secret-per-workspace interface
Environment-specific configuration
Google provider configuration
HCP Terraform-friendly variables
Simplified outputs
Optional CMEK configuration
Optional secret-level IAM configuration
Files
secret-manager/
├── versions.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
versions.tf
Defines:

Required Terraform version
Required Google provider version
Google provider configuration
Authentication is not stored in the repository. It is expected to be supplied by the execution environment, such as HCP Terraform.

variables.tf
Defines the caller-facing variables used to configure:

GCP project
Provider region
Secret name
Replication strategy
Optional KMS key
User-managed replicas
Labels
Optional IAM access
main.tf
Calls the reusable Secret Manager module.

The reusable module supports multiple secrets, but this caller creates one logical secret with the internal map key:

main
The actual Secret Manager resource name is supplied through:

var.secret_id
outputs.tf
Exposes simplified values for the secret managed by this caller:

Secret ID
Fully qualified secret resource name
Replication configuration
Secret-level IAM assignments
terraform.tfvars
Environment-specific values are intentionally not committed to the repository.

HCP Terraform workspace variables or project-level variable sets should provide the required values.

Module Source
The caller consumes the reusable module using:

source = "git::https://github.com/Kedesai/terraform.git//gcp/secret-manager"
During active development, the caller can consume the default branch.

After the reusable module is released, the source should be pinned to a tag:

source = "git::https://github.com/Kedesai/terraform.git//gcp/secret-manager?ref=v1.0.0"
Pinning the module protects callers from unexpected changes to the reusable module.

Required Variables
The simplest deployment requires:

project_id = "my-gcp-project"
secret_id  = "application-secret"
In HCP Terraform, create the following Terraform variables:

project_id
secret_id
Optional Variables
The following variables have defaults and only need to be supplied when their default values must be overridden:

region
replication_type
kms_key_name
user_managed_replicas
labels
iam_role
iam_members
Default behavior:

region           = "us-central1"
replication_type = "AUTOMATIC"
kms_key_name     = null

user_managed_replicas = []

labels = {
  managed_by = "terraform"
}

iam_role    = "roles/secretmanager.secretAccessor"
iam_members = []
Example: Automatic Replication
This is the simplest deployment.

project_id = "my-gcp-project"
secret_id  = "application-secret"
The caller uses:

replication_type = "AUTOMATIC"
by default.

No secret-level IAM assignment is created unless iam_members is supplied.

Example: Automatic Replication with Labels
project_id = "my-gcp-project"
secret_id  = "application-secret"

labels = {
  managed_by  = "terraform"
  environment = "dev"
  application = "example"
}
Example: Automatic Replication with CMEK
Supply the fully qualified KMS Crypto Key identifier:

project_id = "my-gcp-project"
secret_id  = "application-secret"

replication_type = "AUTOMATIC"

kms_key_name = "projects/my-gcp-project/locations/us-central1/keyRings/platform-keyring/cryptoKeys/platform-key"
The KMS key can be created by the reusable KMS module and shared with this workspace through HCP Terraform remote-state outputs or a workspace variable.

Example architecture:

KMS workspace
      |
      | crypto_key_id
      v
Secret Manager workspace
      |
      v
Secret Manager secret using CMEK
Example: User-Managed Replication
project_id = "my-gcp-project"
secret_id  = "database-secret"

replication_type = "USER_MANAGED"

user_managed_replicas = [
  {
    location = "us-central1"
  },
  {
    location = "us-east1"
  }
]
When replication_type is USER_MANAGED, at least one replica must be specified.

Example: User-Managed Replication with CMEK
Each replica can specify its own location-compatible KMS key.

project_id = "my-gcp-project"
secret_id  = "database-secret"

replication_type = "USER_MANAGED"

user_managed_replicas = [
  {
    location     = "us-central1"
    kms_key_name = "projects/my-gcp-project/locations/us-central1/keyRings/central-keyring/cryptoKeys/secrets-key"
  },
  {
    location     = "us-east1"
    kms_key_name = "projects/my-gcp-project/locations/us-east1/keyRings/east-keyring/cryptoKeys/secrets-key"
  }
]
For user-managed replication, the top-level kms_key_name variable is not used. The KMS key is configured individually for each replica.

Example: Secret-Level IAM Access
Use iam_members to grant selected identities access to the secret.

project_id = "my-gcp-project"
secret_id  = "application-secret"

iam_role = "roles/secretmanager.secretAccessor"

iam_members = [
  "serviceAccount:application-sa@my-gcp-project.iam.gserviceaccount.com"
]
The reusable module uses secret-level IAM assignments. This avoids granting access to every secret in the project.

The service account member value can be obtained from the reusable service-account module:

serviceAccount:<service-account-email>
Example: CMEK and IAM Together
project_id = "my-gcp-project"
secret_id  = "application-secret"

replication_type = "AUTOMATIC"

kms_key_name = "projects/my-gcp-project/locations/us-central1/keyRings/platform-keyring/cryptoKeys/platform-key"

iam_role = "roles/secretmanager.secretAccessor"

iam_members = [
  "serviceAccount:application-sa@my-gcp-project.iam.gserviceaccount.com"
]

labels = {
  managed_by  = "terraform"
  environment = "dev"
  application = "example"
}
HCP Terraform Configuration
A suggested workspace name is:

gcp-secret-manager
Suggested workspace settings:

Working directory: secret-manager
Auto apply: Disabled
Speculative plans: Enabled
The workspace should be connected to:

Kedesai/call-gcp-terraform
The HCP Terraform working directory should be:

secret-manager
Suggested HCP Terraform Variables
Required:

project_id
secret_id
Optional:

region
replication_type
kms_key_name
user_managed_replicas
labels
iam_role
iam_members
Collection variables must be entered using HCL syntax.

Example labels value:

{
  managed_by  = "terraform"
  environment = "dev"
  application = "example"
}
Example iam_members value:

[
  "serviceAccount:application-sa@my-gcp-project.iam.gserviceaccount.com"
]
Example user_managed_replicas value:

[
  {
    location = "us-central1"
  },
  {
    location = "us-east1"
  }
]
Outputs
secret_id
The Secret Manager secret ID:

output "secret_id" {
  value = module.secret_manager.secret_ids["main"]
}
secret_name
The fully qualified Secret Manager resource name:

output "secret_name" {
  value = module.secret_manager.secret_names["main"]
}
secret_replication
The replication configuration returned by the reusable module:

output "secret_replication" {
  value = module.secret_manager.secret_replication["main"]
}
secret_iam_members
The secret-level IAM assignments created by this caller:

output "secret_iam_members" {
  value = module.secret_manager.secret_iam_members
}
The IAM output is empty when iam_members is empty.

Security Boundary
This caller creates the Secret Manager secret container and its supporting configuration.

It intentionally does not accept a secret payload variable and does not create a Secret Manager secret version.

Do not add a variable such as:

variable "secret_value" {
  type      = string
  sensitive = true
}
Simply marking a Terraform variable as sensitive prevents normal display in logs, but does not make Terraform state an appropriate secret-delivery system.

Secret payload delivery should be handled through a separate approved process.

Relationship to Other Modules
Reusable KMS module
      |
      | crypto_key_id
      v
Secret Manager caller
      |
      +-- Secret container
      +-- Replication
      +-- Optional CMEK
      +-- Optional IAM
                ^
                |
Reusable Service Account module
      |
      +-- service_account_member
The Secret Manager caller can consume:

A KMS Crypto Key ID from the KMS workspace
A service-account IAM member from the service-account workspace
The caller does not create either dependency itself.

Validation Commands
Before committing changes, run:

terraform fmt -recursive
terraform init
terraform validate
terraform plan
To inspect the outputs after deployment:

terraform output
Design Principles
This caller follows the shared repository standards:

Reusable resource logic remains in the central Terraform repository
Environment configuration remains in the caller repository
Provider configuration belongs to the caller
Authentication is supplied by the execution environment
Caller variables remain simple where practical
Optional capabilities are enabled only when requested
Service modules consume outputs from other modules rather than recreating them
Secret payloads are kept outside Terraform infrastructure state
Reusable module versions should be pinned for stable deployments