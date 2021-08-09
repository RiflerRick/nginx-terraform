provider "google" {
    project = "global-image-sharing"
   # credentials = "svc-account-key.json"
}

# terraform {
#   backend "gcs" {
#     bucket  = "tf-state-dev"
#     prefix  = "terraform/state"
#   }
# }

resource "google_compute_instance" "nginx_server" {
  name         = "nginx-server"
  machine_type = "e2-medium"
  zone         = "asia-south2-a"
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
    "ssh-keys" = "jenkins:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvSOSkwD6y0CrY20ij29MAmmXsu1OZsi8BwXvwt3pvQ jenkins"
    server = "nginx-server"
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "438120450912-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}
