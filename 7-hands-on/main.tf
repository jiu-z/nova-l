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
  project = "cal-2956-3e70f5b1263b"
  region = "us-central1"
}
resource "google_storage_bucket" "file-store" {
  name     = "file-store-RANDOM_NUMBERS" # Replace with random numbers
  location = "US"
}
resource "google_storage_bucket_object" "file" {
  name   = "testFile"
  source = "file.txt"
  bucket = "file-store-RANDOM_NUMBERS" # Replace with random numbers
}
