# Remote state location for dev, prod, & qa child folders
remote_state {
  backend = "gcs"
 
  config = {
    bucket = "lab-bucket-cal-2831-87e766538bbd"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    credentials = "/home/project/.sa_key"
    project = "cal-2831-87e766538bbd"
    location = "us-central1"
  }
}
 
# Generate a Google provider block for each child folder
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = "/home/project/.sa_key"
  project = "cal-2831-87e766538bbd"
  region = "us-central1"
}
  EOF
}