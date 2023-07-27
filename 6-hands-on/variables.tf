variable "project_id" {
  type = string
}

variable "account_id_cloud_run" {
  type = string
}

variable "roles_permitions" {
  type = list(object({
    account_id  = string
    role_id     = string
    title       = string
    description = string
    permissions = list(string)
  }))
}

# variable "custom_parts" {
#   type = list(object({
#     account_id  = string
#     role_id     = string
#     title       = string
#     description = string
#     permissions = list(string)
#   }))
# }

# variable "predefined_parts" {
#   type = list(object({
#     account_id  = string
#     role_id     = string
#     title       = string
#     description = string
#     permissions = list(string)
#   }))
# }