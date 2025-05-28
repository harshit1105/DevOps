################################
# Description : Help me define variables for compute instance for GCP based upon below variables

 # instance_name = var.instance_name
 # project       = var.project
 # zone          = var.zone
 # machine_type  = var.machine_type
################################

# Define Variable instance_name

variable "instance_name_1" {
  description = "Name of the ActiveGate instance"
  type        = string
}

variable "project" {
  description = "Project name"
  type = string
}

variable "zone" {
  description = "Zone name"
  type = string
}

variable "machine_type" {
  description = "machine name"
  type = string
}

#variable "dynatrace_api_token" {
#  description = "Dynatrace API Token"
#  type = string
#  sensitive   = true
#}

variable "service_account_email" {
  description = "The email of the service account to attach to the instance"
  type        = string
}