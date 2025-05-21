################################
# Description : Help me define variables for compute instance for GCP based upon below variables

 # instance_name = var.instance_name
 # project       = var.project
 # zone          = var.zone
 # machine_type  = var.machine_type
################################

# Define Variable instance_name

variable "name" {
  description = "Name of the firewall rule"
  type = string
}
variable "network" {
  description = "Network to which the firewall rule applies"
  type = string
}
variable "ports" {
  description = "List of ports to allow"
  type = list(string)
}
variable "source_ranges" {
  description = "List of source IP ranges to allow"
  type = list(string)
}
variable "target_tags" {
  description = "List of target tags to apply the firewall rule to"
  type = list(string)
}
variable "project" {
  description = "Project name"
  type = string
}