locals {
  # google_service_account リソースを作成し、同じアカウントを繰り返し作成しないようにします
  account_ids = toset([for item in var.service_account_roles_permitions : item.account_id])
}

# Google Project IAM Member リソースを作成
resource "google_project_iam_member" "custom_roles_members" {
  for_each = {
    for role in var.service_account_roles_permitions : role.role_id => role
  }

  project = var.project_id
  role    = google_project_iam_custom_role.custom_roles[each.key].name
  member  = "serviceAccount:${google_service_account.service_accounts[each.value.account_id].email}"

  depends_on = [
    google_service_account.service_accounts,
    google_project_iam_custom_role.custom_roles,
  ]
}

# google_service_account リソースを作成
resource "google_service_account" "service_accounts" {
  for_each     = local.account_ids
  
  project      = var.project_id
  account_id   = each.key
  display_name = "Service Account for ${each.key}"
}

# google_project_iam_custom_role リソースを作成
resource "google_project_iam_custom_role" "custom_roles" {
  for_each = {
    for item in var.service_account_roles_permitions : item.role_id => item
  }

  project     = var.project_id
  role_id     = each.key
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions

  depends_on = [google_service_account.service_accounts]
}
