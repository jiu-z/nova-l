terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.69.1"
    }
  }
}

provider "google" {
  project = "era-ax"
  region = var.region
}

resource "google_compute_network" "ca-network" {
  name                    = "ca-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

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
          "133.32.130.12"
        ]
      }
    }
    description = "Next-Gen-Dev team :)"
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

resource "google_compute_url_map_path_matcher" "user_path_matcher" {
  name      = "user-path-matcher"
  url_map   = google_compute_url_map.default.self_link
  path_rule = "/user/*"

  route_action {
    backend_service = google_compute_backend_service.webserver.id
  }
}

resource "google_compute_url_map_path_matcher" "gateway_path_matcher" {
  name      = "gateway-path-matcher"
  url_map   = google_compute_url_map.default.self_link
  path_rule = "/gateway/*"

  route_action {
    backend_service = google_compute_backend_service.webserver.id
  }
}


