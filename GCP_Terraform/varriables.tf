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
  type        = string
}

variable "zone" {
  description = "Zone name"
  type        = string
}

variable "machine_type" {
  description = "machine name"
  type        = string
}

variable "dynatrace_api_token" {
  description = "Dynatrace API Token"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "Service Account ID"
  type        = string
}
variable "display_name" {
  description = "Service Account Display Name"
  type        = string
}
variable "secret_id" {
  description = "Secret ID"
  type        = string
}

variable "name" {
  description = "Name of the firewall rule"
  type        = string
}
variable "network" {
  description = "Network to which the firewall rule applies"
  type        = string
}
variable "ports" {
  description = "List of ports to allow"
  type        = list(string)
}
variable "source_ranges" {
  description = "List of source IP ranges to allow"
  type        = list(string)
}
variable "target_tags" {
  description = "List of target tags to apply the firewall rule to"
  type        = list(string)
}