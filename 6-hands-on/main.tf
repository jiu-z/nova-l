locals {
  account_ids = toset([for item in var.roles_permitions : item.account_id])
  predefined_parts = [for item in var.roles_permitions : item if can(regex("roles/.*", item.role_id))]
  custom_parts = [for item in var.roles_permitions : item if !can(regex("roles/.*", item.role_id))]
}

# google_service_account リソースを作成
resource "google_service_account" "service_accounts" {
  for_each = local.account_ids

  project      = var.project_id
  account_id   = each.key
  display_name = "Service Account for ${each.key}"
}

# google_project_iam_custom_role リソースを作成
resource "google_project_iam_custom_role" "custom_roles" {
  for_each = {
    for item in local.custom_parts : item.role_id => item
  }

  project     = var.project_id
  role_id     = each.key
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
}

# Google Project IAM Member リソースを作成
resource "google_project_iam_member" "custom_roles_members" {
  for_each = {
    for role in local.custom_parts : role.role_id => role
  }

  project = var.project_id
  role    = google_project_iam_custom_role.custom_roles[each.key].name
  member  = "serviceAccount:${google_service_account.service_accounts[each.value.account_id].email}"
}

# Create google_project_iam_member resources to bind service accounts with roles
resource "google_project_iam_member" "custom_parts_binding" {
  for_each = { for item in local.predefined_parts : item.account_id => item }

  project = var.project_id
  role    = each.value.role_id
  member  = "serviceAccount:${google_service_account.service_accounts[each.key].email}"
}