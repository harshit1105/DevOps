# Create a Service Account  

resource "google_service_account" "default" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project
}

resource "google_secret_manager_secret_iam_member" "accessor" {
  secret_id = var.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.default.email}"
  project   = var.project
  
}