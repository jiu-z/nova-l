resource "google_compute_instance" "server" {
  name = "lab-server"
  machine_type = "f1-micro"
  zone = "us-central1-a"
 
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = var.subnetwork_id
    access_config {
    }
  }
}