terraform {
  backend "gcs" {
    bucket = "demoghaa"
    prefix = "resource-creation/"
  }
}
