provider "google" {
    project = "global-image-sharing"
    region = "ap-south2"
    credentials = "/home/jenkins/svc-account-key.json"
}

# terraform {
#   backend "gcs" {
#     bucket  = "tf-state-dev"
#     prefix  = "terraform/state"
#   }
# }

resource "google_compute_instance" "nginx_server" {
  name         = "jumpbox"
  machine_type = "e2-medium"
  zone         = "ap-south2-b"
  tags = ["us-central1", "nginx-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # #Local SSD disk
  # scratch_disk {
  #   interface = "SCSI"
  # }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  metadata = {
    server = "nginx-server"
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "438120450912-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}