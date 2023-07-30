terraform {
  backend "gcs" {}
}

resource "google_compute_network" "prod-network" {
  name                    = "prod-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "prod-subnetwork" {
  name          = "prod-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.prod-network.id
}
