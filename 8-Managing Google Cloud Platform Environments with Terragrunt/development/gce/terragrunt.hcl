# Use remote GCE module
# https://github.com/cloudacademy/terraform-gcp-calabmodules
terraform {
  source = "git::github.com/cloudacademy/terraform-gcp-calabmodules.git//gce?ref=v0.0.2"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# Define module dependencies
dependency "network" {
  config_path = find_in_parent_folders("network")
}

# Collect values from parent env_vars.yaml file and set as local variables
locals {
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

# Pass input values into remote module
inputs = {
  environment = local.env_vars.environment
  subnetwork_id = dependency.network.outputs.subnetwork_id
  server_count = local.env_vars.server_count
  server_name = local.env_vars.server_name
  machine_type = local.env_vars.machine_type
  zone = local.env_vars.zone
  image = local.env_vars.image
}