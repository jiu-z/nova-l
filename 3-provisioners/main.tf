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
  project = "cal-2907-b13b50f091b3"
  region = "us-central1"
}
resource "google_storage_bucket" "file-store" {
  name     = "file-store-adozoo123" # Replace with random characters
  location = "US"
  # Creation-time Provisioner
  provisioner "local-exec" {
    command = "gsutil cp $OBJECT gs://$BUCKET"
    environment = {
      BUCKET = self.name # Equivalent to "google_storage_bucket.file-store.name"
      OBJECT = "test.txt" # Path to local file
    }
  }
  
  # Destroy-time Provisioner
  provisioner "local-exec" {
    when = destroy
    command = "gsutil rm gs://$BUCKET/$OBJECT"
    environment = {
      BUCKET = self.name
      OBJECT = "test.txt"
    }
  }
}
