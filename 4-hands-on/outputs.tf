# cloud_run_id出力
output "acount_cloud_run_id" {
  description = "google_service_account cloud_run id"
  value       = google_service_account.cloud_run.id
}

# role_id出力
output "all_role_ids" {
  description = " custom_roles id"
  value = [for role in var.service_account_roles_permitions : role.role_id]
}

# バインドされたロールの名前を出力します
output "bound_role_names" {
  description = "service acount bound_role_names"
  value = [for role_member in google_project_iam_member.custom_roles_members : role_member.role]
}