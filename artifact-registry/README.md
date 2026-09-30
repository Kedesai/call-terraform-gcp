GCP Artifact Registry Caller
Terraform caller configuration for deploying one Google Artifact Registry repository using the reusable Artifact Registry module.

Architecture
HCP Terraform
      |
      | Simple variables
      v
call-gcp-terraform/artifact-registry
      |
      | Reusable module inputs
      v
terraform/gcp/artifact-registry
      |
      +-- Artifact Registry repository
      +-- Optional Docker configuration
      +-- Optional CMEK
      +-- Optional repository IAM
Repository Responsibilities
Reusable implementation:

Kedesai/terraform/gcp/artifact-registry
Environment-specific caller:

Kedesai/call-gcp-terraform/artifact-registry
Required Variables
The simplest Docker repository deployment requires:

project_id    = "my-gcp-project"
repository_id = "application-images"
Defaults provide:

region              = "us-central1"
repository_location = "us-central1"
repository_format   = "DOCKER"
immutable_tags      = false
kms_key_id           = null
Docker Repository
project_id = "my-gcp-project"

repository_id       = "application-images"
repository_location = "us-central1"
repository_format   = "DOCKER"

immutable_tags = true
CMEK
The caller uses the platform-standard input:

kms_key_id
This aligns with the KMS caller:

KMS caller
    |
    +-- crypto_key_id
              |
              v
Artifact Registry caller
    |
    +-- kms_key_id
Supplying the KMS key does not by itself configure the Artifact Registry service identity's permissions on that key. Required KMS IAM access should be managed separately.

Repository IAM
IAM access is optional.

Example reader access:

iam_role = "roles/artifactregistry.reader"

iam_members = [
  "serviceAccount:application@my-project.iam.gserviceaccount.com"
]
For a CI/CD identity that needs to push artifacts, an appropriate writer role can instead be supplied through iam_role.

HCP Terraform
Suggested workspace:

gcp-artifact-registry
Repository:

Kedesai/call-gcp-terraform
Working directory:

artifact-registry
Required Terraform variables:

project_id
repository_id
Optional variables only need to be configured when overriding caller defaults.

Outputs
The caller exposes:

repository_id
repository_name
repository_location
repository_iam_members
Validation
Before committing changes:

terraform fmt -recursive
terraform init
terraform validate
terraform plan
Design Principles
Resource implementation remains in the reusable repository
Environment configuration remains in the caller
Provider configuration remains in the caller
Authentication remains outside source control
One caller workspace can consume only the capabilities it needs
IAM remains optional
CMEK remains optional
kms_key_id is the standard CMEK interface between our GCP callers