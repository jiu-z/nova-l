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
  project = "cal-3044-8476764cd5c8"
  region = "us-central1"
}
resource "google_storage_bucket" "file-store" {}
