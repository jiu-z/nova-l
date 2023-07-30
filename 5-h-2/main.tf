terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}
provider "google" {
  credentials = "${file("../.sa_key")}"
  project = "cal-3030-a3bb33176e42"
  region = var.region
}
resource "google_compute_subnetwork" "ca-subnetwork" {
  name          = "ca-subnetwork"
  ip_cidr_range = var.subnetwork_range
  region        = var.region
  network       = google_compute_network.ca-network.id
}
resource "google_compute_network" "ca-network" {
  name                    = "ca-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}
module "bastion" {
    count        = var.create_bastion ? 1 : 0
    source       = "./modules/gce-bastion"
    name         = var.bastion_name
    machine_type = var.machine_type
    zone         = var.zone
    image        = var.image
    subnetwork   = google_compute_subnetwork.ca-subnetwork.id
}
