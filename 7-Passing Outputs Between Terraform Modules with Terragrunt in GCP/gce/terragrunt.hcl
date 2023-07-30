# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}
 
dependency "network" {
  config_path = find_in_parent_folders("network")
}
 
inputs = {
  subnetwork_id = dependency.network.outputs.subnetwork_id
}