# Create a Compute Instance
data "google_secret_manager_secret_version" "dynatrace_token" {
  secret  = "dynatrace_secret"
  project = var.project
}

resource "google_compute_instance" "linux_instance" {
  name         = var.instance_name_1
  machine_type = var.machine_type
  project = var.project
  zone         = var.zone
  tags = ["debian-instance"]

   boot_disk {
    auto_delete = true
    device_name = var.instance_name_1

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
    wget -O Dynatrace-ActiveGate-Linux-x86-1.313.24.sh "https://ixw33767.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?arch=x86" --header="Authorization: Api-Token $DYNATRACE_API_TOKEN"
    wget https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha-256"; boundary="--SIGNED-INSTALLER"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat Dynatrace-ActiveGate-Linux-x86-1.313.24.sh ) | openssl cms -verify -CAfile dt-root.cert.pem > /dev/null
    /bin/bash Dynatrace-ActiveGate-Linux-x86-1.313.24.sh
    rm -rf Dynatrace-ActiveGate-Linux-x86-1.313.24.sh
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
