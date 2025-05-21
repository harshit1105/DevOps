# Create a Firewall Rule for RDP
resource "google_compute_firewall" "allow" {
  name    = var.name
  network = var.network
  project = var.project

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}