variable "project_id" {
  type = string
}

variable "account_id_cloud_run" {
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
