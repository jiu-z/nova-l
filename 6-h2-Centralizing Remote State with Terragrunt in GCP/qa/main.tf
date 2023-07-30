terraform {
  backend "gcs" {}
}

resource "google_compute_network" "qa-network" {
  name                    = "qa-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "qa-subnetwork" {
  name          = "qa-subnetwork"
  ip_cidr_range = "10.1.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.qa-network.id
}
