terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.69.1"
    }
  }
}

provider "google" {
  project = "pacific-ethos-388512"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_storage_bucket" "file-store" {
  name     = "file-store-7312815287351254182" # Replace with random numbers
  location = "US"
}

# resource "google_storage_bucket_object" "file" {
#   name   = "testFile"
#   source = "file.txt"
#   bucket = "file-store-RANDOM_NUMBERS" # Replace with random numbers
# }

resource "google_storage_bucket_object" "file" {
  name   = "testFile"
  source = "file.txt"
  bucket = google_storage_bucket.file-store.name # file-store bucket dependency
}
