terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.69.1"
    }
  }
}

provider "google" {
  project = "era-ax"
  region = var.region
}

# resource "google_compute_subnetwork" "ca-subnetwork" {
#   name          = "ca-subnetwork"
#   ip_cidr_range = var.subnetwork_range
#   region        = var.region
#   network       = google_compute_network.ca-network.id
# }

resource "google_compute_network" "ca-network" {
  name                    = "ca-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

# resource "google_compute_instance" "instance" {
#   name         = "ca-lab"
#   machine_type = var.machine_type
#   zone         = var.zone
#   boot_disk {
#     initialize_params {
#       image = var.image
#     }
#   }
#   network_interface {
#     subnetwork = google_compute_subnetwork.ca-subnetwork.id
#     access_config {}
#   }
# }
