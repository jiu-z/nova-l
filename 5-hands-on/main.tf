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

# resource "google_firebase_android_app" "default" {
#   provider = google-beta
#   project = var.project_id
#   display_name = "android nova-kk"
#   package_name = "android.nova-kk.app"
#   sha1_hashes = ["2145bdf698b8715039bd0e83f2069bed435ac21c"]
#   sha256_hashes = ["2145bdf698b8715039bd0e83f2069bed435ac21ca1b2c3d4e5f6123456789abc"]
#   api_key_id = google_apikeys_key.android.uid
# }

# resource "google_apikeys_key" "android" {
#   provider = google-beta

#   name         = "api-key"
#   display_name = "Display Name"
#   project = var.project_id

#   restrictions {
#     android_key_restrictions {
#       allowed_applications {
#         package_name     = "android.nova-kk.app"
#         sha1_fingerprint = "2145bdf698b8715039bd0e83f2069bed435ac21c"
#       }
#     }
#   }
# }

# resource "google_firebase_apple_app" "full" {
#   provider = google-beta
#   project = var.project_id
#   display_name = "nova-kk Full"
#   bundle_id = "apple.app.nova-kk"
#   app_store_id = "nova-kk"
#   team_id = "9987654321"
#   api_key_id = google_apikeys_key.apple.uid
# }

# resource "google_apikeys_key" "apple" {
#   provider = google-beta

#   name         = "api-key-apple"
#   display_name = "nova-kk Full"
#   project = var.project_id

#   restrictions {
#     ios_key_restrictions {
#       allowed_bundle_ids = ["apple.app.nova-kk"]
#     }
#   }
# }