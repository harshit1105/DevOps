################################
# Description : Create a Windows Compute Instance in GCP
# Author      : Harshit
# Created on  : 19-05-2025
# Details    : This script creates a Compute Instance in GCP using Terraform modules
# Create different modules for different resources
#              and use them in the main.tf file.
#              This is a simple example of how to create a Compute Instance in GCP using Terraform
################################

# Create a module for the Compute Instance using varriables

locals {
  instance_names = [
    "deb-dyn-01",
    "deb-dyn-02",
    "deb-dyn-03"
  ]
}

module "firewall" {
  source        = "./modules/firewall"
  name          = var.name
  network       = var.network
  ports         = var.ports
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
  project       = var.project
}


module "service_account" {
  source       = "./modules/service_account"
  account_id   = var.account_id
  display_name = var.display_name
  secret_id    = var.secret_id
  project      = var.project
}

module "linux_instance" {
  source                = "./modules/compute"
  for_each              = toset(local.instance_names)
  instance_name         = each.value
  project               = var.project
  zone                  = var.zone
  machine_type          = var.machine_type
  dynatrace_api_token   = var.dynatrace_api_token
  service_account_email = module.service_account.default_email
  depends_on            = [module.service_account]
}
