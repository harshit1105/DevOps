################################
# Description : Help me define variables for compute instance for GCP based upon below variables

 # instance_name = var.instance_name
 # project       = var.project
 # zone          = var.zone
 # machine_type  = var.machine_type
################################

# Define Variable instance_name
variable "project" {
  description = "Project name"
  type = string
}

variable "account_id" {
  description = "Service account ID"
  type        = string
  default     = "windows-instance-sa"
}
variable "display_name" {
  description = "Service Account Display Name"
  type = string
}
variable "secret_id" {
  description = "Secret ID"
  type = string
}