# Use remote Network module
terraform {
  source = "git::github.com/cloudacademy/terraform-gcp-calabmodules.git//network?ref=v0.0.2"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# Collect values from parent env_vars.yaml file and set as local variables
locals {
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

# Pass data into remote module with inputs
inputs = {
  environment = local.env_vars.environment
  ip_cidr_range = local.env_vars.ip_cidr_range
  region = local.env_vars.region
}
