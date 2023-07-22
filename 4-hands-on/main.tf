

# 创建 Google Project IAM Custom Role 作成
resource "google_project_iam_custom_role" "custom_roles" {
  for_each = {
    for role in var.service_account_roles_permitions : role.role_id => role
  }

  project     = var.project_id
  role_id     = each.value.role_id
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
}

# Google Project IAM Member　作成
resource "google_project_iam_member" "custom_roles_members" {
  for_each = {
    for role in var.service_account_roles_permitions : role.role_id => role
  }

  project = var.project_id
  role    = google_project_iam_custom_role.custom_roles[each.key].name
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_service_account" "pub_sub" {
  display_name = var.account_id_pub_sub # pub_sub開発用サービスアカウント
  account_id   = var.account_id_pub_sub
  depends_on = [
    google_project_iam_custom_role.custom_roles,
  ]
}

# Google Cloud Service Account　作成
resource "google_service_account" "cloud_run" {
  display_name = var.account_id_cloud_run # cloud_run開発用サービスアカウント
  account_id   = var.account_id_cloud_run
  depends_on = [
    google_project_iam_custom_role.custom_roles,
  ]
}
