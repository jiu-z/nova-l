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
  region  = "us-central1"
  zone    = "us-central1-c"
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
