remote_state {
  backend = "gcs"
  config = {
    bucket = "pacific-ethos-388512-tf-state"
    prefix = "${local.env_vars.environment}/${path_relative_to_include()}/terraform.tfstate"
    project = "pacific-ethos-388512"
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
      version = "4.75.0"
    }
  }
  backend "gcs" {}
}
provider "google" {
  project = "pacific-ethos-388512"
  region = "us-central1"
}
  EOF
}
 
# Collect values from env_vars.yaml and set as local variables
locals {
  env_vars = yamldecode(file("env_vars.yaml"))
}