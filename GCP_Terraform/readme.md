# GCP Terraform Modular Compute Deployment

This repository provides a modular Terraform setup to deploy multiple Compute Engine instances on Google Cloud Platform (GCP), with a shared service account (with Secret Manager access) and a firewall rule for SSH (TCP:22) access.

## Structure

```
.
├── main.tf
├── variables.tf
├── terraform.tfvars
├── modules/
│   ├── compute/
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── firewall/
│   │   ├── main.tf
│   │   └── variables.tf
│   └── service_account/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

## Features

- **Multiple Compute Instances:** Easily deploy 3 (or more) Linux VMs using a single module and a list of names.
- **Single Service Account:** All VMs share one service account, which is granted access to Secret Manager.
- **Firewall Module:** A reusable firewall module allows SSH (TCP:22) from any source.
- **Secret Manager Integration:** The Dynatrace API token is securely fetched from Secret Manager and injected into each VM via startup script.

## Usage

1. **Clone the repository and navigate to the root directory.**

2. **Edit `terraform.tfvars` with your project-specific values:**
    ```hcl
    project             = "your-gcp-project-id"
    zone                = "your-gcp-zone"
    machine_type        = "n1-standard-2"
    dynatrace_api_token = "YOUR_DYNATRACE_TOKEN"
    name                = "allow-ssh"
    network             = "default"
    ports               = ["22"]
    source_ranges       = ["0.0.0.0/0"]
    target_tags         = ["debian-instance"]
    account_id          = "windows-instance-sa"
    display_name        = "Windows Instance Service Account"
    secret_id           = "dynatrace-api-token"
    ```

3. **Initialize Terraform:**
    ```sh
    terraform init
    ```

4. **Review the plan:**
    ```sh
    terraform plan
    ```

5. **Apply the configuration:**
    ```sh
    terraform apply
    ```

## Modules

- **compute:** Provisions Compute Engine instances and installs Dynatrace using a startup script.
- **firewall:** Creates a firewall rule for SSH access.
- **service_account:** Creates a service account and grants it Secret Manager access.

## Customization

- To add or remove instances, edit the `local.instance_names` list in `main.tf`.
- To change firewall rules, update the variables in `terraform.tfvars` or the firewall module.

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) (for authentication)
- GCP project with billing enabled
- Secret Manager API enabled

## Notes

- The service account is created once and used by all VMs.
- The Dynatrace API token must be stored in Secret Manager under the secret ID you specify.
- All resources are modular and reusable.

---

**Author:** Harshit  
**Created:** 19-05-2025
