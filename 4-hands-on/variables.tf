variable "auto_create_subnetworks" {
  description = "Automatically create subnetworks"
  type        = string
}
variable "region" {
  description = "Deployment Region"
  type        = string
}

variable "project_id" {
  type = string
}

variable "account_id_cloud_run" {
  type = string
}

variable "account_id_pub_sub" {
  type = string
}

variable "service_account_roles_permitions" {
  type = list(object({
    role_id     = string
    title       = string
    description = string
    permissions = list(string)
  }))
}
