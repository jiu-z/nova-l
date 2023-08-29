terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.69.1"
    }
  }
}

provider "google" {
  project = "era-ax"
  region  = var.region
}

resource "google_compute_network" "ca-network" {
  name                    = "ca-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

##Front End
# git pull && terraform init && terraform apply -auto-approve
# git add . && git commite -m update && git push
# resource "google_project_service" "project" {
#   project            = var.project_id
#   service            = "run.googleapis.com"
#   disable_on_destroy = false
# }

resource "google_cloud_run_service" "webserver" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image
      }
    }
  }
  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["run.googleapis.com/client-name"],
      metadata.0.annotations["run.googleapis.com/client-version"],
      template[0].spec[0].containers[0].image,
      template[0].spec[0].containers[0].env
    ]
  }

  autogenerate_revision_name = true
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.webserver.location
  project     = google_cloud_run_service.webserver.project
  service     = google_cloud_run_service.webserver.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_compute_region_network_endpoint_group" "node_group" {
  name                  = "${var.service_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id
  cloud_run {
    service = google_cloud_run_service.webserver.name
  }
}

resource "google_compute_backend_service" "webserver" {
  name                  = google_cloud_run_service.webserver.name
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  security_policy       = google_compute_security_policy.default_policy.self_link
  backend {
    group = google_compute_region_network_endpoint_group.node_group.id
  }
  log_config {
    enable      = true
    sample_rate = 1
  }
}

##Security
resource "google_compute_security_policy" "default_policy" {
  name = var.policy_name

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          "124.39.30.241",
          "133.201.11.225",
          "121.109.156.28",
          "114.155.123.10",
          "122.26.96.8",
          "118.7.70.128",
          "59.7.248.104",
          "118.240.180.6",
          "133.32.130.12"
        ]
      }
    }
    description = "Next-Gen-Dev team :)"
  }

  rule {
    action   = "allow"
    priority = "1001"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["222.230.189.170/31", "222.230.189.172/31"]
      }
    }
    description = "CAINZ VPN"
  }

  rule {
    action   = "allow"
    priority = "1002"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["210.149.129.66/31", "210.149.129.113/32", "210.149.129.114/31", "210.149.129.116/32"]
      }
    }
    description = "CAINZ IP VPN Backup"
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default deny"
  }
}

# ## LB
data "google_compute_ssl_certificate" "cainz_com" {
  name = var.certificate_name
}

resource "google_compute_ssl_policy" "cainzapp_custom_policy" {
  name            = "cainzapp-custom-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_global_address" "default" {
  name = var.lb_name
}

resource "google_compute_target_https_proxy" "default" {
  name             = var.lb_name
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [data.google_compute_ssl_certificate.cainz_com.certificate_id]
  ssl_policy       = google_compute_ssl_policy.cainzapp_custom_policy.name
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.lb_name
  target                = google_compute_target_https_proxy.default.self_link
  ip_address            = google_compute_global_address.default.address
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

# resource "google_compute_url_map" "default" {
#   name            = var.lb_name
#   default_service = google_compute_backend_service.webserver.id

#   path_matcher {
#     name = "redirect-to-https"
#     default_url_redirect {
#       https_redirect         = true
#       redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
#       strip_query            = false
#     }
#   }
# }

resource "google_compute_url_map" "default" {
  name            = var.lb_name
  default_service = google_compute_backend_service.webserver.id
  path_matcher {
    name = "redirect-to-https"
    default_url_redirect {
      https_redirect         = true
      redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
      strip_query            = false
    }
  }
  host_rule {
    hosts        = ["*"]
    path_matcher = "mysite"
  }

  host_rule {
    hosts        = ["myothersite.com"]
    path_matcher = "otherpaths"
  }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_service.webserver.id

    path_rule {
      paths   = ["/home"]
      service = google_compute_backend_service.webserver.id
    }
  }
  path_matcher {
    name            = "otherpaths"
    default_service = google_compute_backend_bucket.static.id
  }
}
