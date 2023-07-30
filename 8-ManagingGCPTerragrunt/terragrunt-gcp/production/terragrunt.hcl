remote_state {
  backend = "gcs"
  config = {
    bucket = "calabs-bucket-1690699541"
    prefix = "${local.env_vars.environment}/${path_relative_to_include()}/terraform.tfstate"
    credentials = "/home/project/.sa_key"
    project = "cal-1639-c60ea2f0a7f5"
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
  backend "gcs" {}
}
provider "google" {
  credentials = "/home/project/.sa_key"
  project = "cal-1639-c60ea2f0a7f5"
  region = "us-central1"
}
  EOF
}
 
# Collect values from env_vars.yaml and set as local variables
locals {
  env_vars = yamldecode(file("env_vars.yaml"))
}