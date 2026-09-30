variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Default GCP region."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "VPC network name."
  type        = string
}

variable "routing_mode" {
  description = "VPC routing mode."
  type        = string
  default     = "GLOBAL"
}

variable "subnet_name" {
  description = "Subnet name."
  type        = string
}

variable "subnet_cidr" {
  description = "Primary subnet CIDR."
  type        = string
}

variable "private_ip_google_access" {
  description = "Enable Private Google Access."
  type        = bool
  default     = true
}

variable "gke_pods_range_name" {
  description = "Secondary range name for GKE Pods."
  type        = string
  default     = "gke-pods"
}

variable "gke_pods_cidr" {
  description = "Secondary CIDR range for GKE Pods."
  type        = string
}

variable "gke_services_range_name" {
  description = "Secondary range name for GKE Services."
  type        = string
  default     = "gke-services"
}

variable "gke_services_cidr" {
  description = "Secondary CIDR range for GKE Services."
  type        = string
}

variable "enable_flow_logs" {
  description = "Enable VPC flow logs."
  type        = bool
  default     = true
}
