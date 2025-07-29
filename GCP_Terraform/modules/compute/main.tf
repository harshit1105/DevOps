# Create a Compute Instance
data "google_secret_manager_secret_version" "dynatrace_token" {
  secret  = "dynatrace-api-token"
  project = var.project
}

resource "google_compute_instance" "linux_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  project = var.project
  zone         = var.zone
  tags = ["debian-instance"]

   boot_disk {
    auto_delete = true
    device_name = var.instance_name

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250513"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

metadata = {
  startup-script = <<-EOT
    #!/bin/bash
    set -x
    exec > /var/log/startup-script.log 2>&1
    DYNATRACE_API_TOKEN='${data.google_secret_manager_secret_version.dynatrace_token.secret_data}'
    wget -O Dynatrace-OneAgent-Linux-1.317.58.20250725-104932.sh "https://nxy41179.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?arch=x86" --header="Authorization: Api-Token $DYNATRACE_API_TOKEN"
    wget https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha-256"; boundary="--SIGNED-INSTALLER"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat Dynatrace-OneAgent-Linux-1.317.58.20250725-104932.sh ) | openssl cms -verify -CAfile dt-root.cert.pem > /dev/null
    /bin/sh Dynatrace-OneAgent-Linux-gcp-india-mum-1.317.58.20250725-104932.sh --set-monitoring-mode=fullstack --set-app-log-content-access=true --set-network-zone=gcp-india-mum --set-host-group=_e_dev_a_app2_p_project2
    rm -rf Dynatrace-OneAgent-Linux-gcp-india-mum-1.317.58.20250725-104932.sh
  EOT
}

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  timeouts {
    create = "10m"
    delete = "5m"
  }
}
