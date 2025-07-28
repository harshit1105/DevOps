##################################
# Description : Defining all the variables here with the values
##################################

zone         = "asia-south1-b"
project      = "observability-466201"
machine_type = "n1-standard-2"


# Define Firewall rule variables

name          = "allow-ssh"
network       = "default"
ports         = ["22"]
source_ranges = ["0.0.0.0/0"]
target_tags   = ["debian-instance"]

# Define service account variables
account_id   = "windows-instance-sa"
display_name = "Windows Instance Service"
secret_id    = "dynatrace-api-token"
instance_name_1 = "activegate-dynatrace-01"

