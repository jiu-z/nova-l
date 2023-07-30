terraform {
  backend "gcs" {}
}

resource "google_compute_network" "dev-network" {
  name                    = "dev-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev-subnetwork" {
  name          = "dev-subnetwork"
  ip_cidr_range = "10.2.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.dev-network.id
}
