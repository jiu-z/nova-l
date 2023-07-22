

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

# Google Cloud Service Account　作成
resource "google_service_account" "cloud_run" {
  display_name = var.account_id_cloud_run # cloud_run開発用サービスアカウント
  account_id   = var.account_id_cloud_run
  depends_on = [
    google_project_iam_custom_role.custom_roles,
  ]
}


resource "google_cloud_run_service" "backend" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/pacific-ethos-388512/node-hello-world/node-hello-world:2f97e2027ebd094084abd616b246bd73669f80e8"
      }
      container_concurrency = 4
      timeout_seconds       = 3600
      # Specify a custom service account for the Cloud Run service
      # service_account_name = "848188805483-compute@developer.gserviceaccount.com"
      service_account_name = "cloud-run-custom-dev@pacific-ethos-388512.iam.gserviceaccount.com"
      
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


