terraform {
  backend "gcs" {
    bucket = "demogha"
    prefix = "resource-creation/"
  }
}
