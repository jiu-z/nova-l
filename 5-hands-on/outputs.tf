# cloud_run_id出力
output "acount_cloud_run_id" {
  description = "google_service_account cloud_run id"
  value       = google_service_account.service_accounts["custom2"].email
}

output "acount_cloud_run2_id" {
  description = "google_service_account cloud_run id"
  value       = google_service_account.service_accounts["custom1"].email
}