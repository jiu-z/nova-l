terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.75.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_security_policy" "default_policy" {
  name = "entry-src"

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default deny"
  }
}

resource "google_project" "default" {
  provider = google-beta

  project_id = var.project_id
  name       = var.project_id

  labels = {
    "firebase" = "enabled"
  }
}

resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.default.project_id
}

resource "google_firebase_project_location" "basic" {
    provider = google-beta
    project = google_firebase_project.default.project

    location_id = "us-central"
}