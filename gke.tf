provider "google" {
  project = var.project
  region  = var.location
  credentials = var.credentials
  zone    = var.zone
}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_name
  display_name = var.service_account_name
}

# create GKE cluster
resource "google_container_cluster" "default" {
  name        = var.cluster_name
  project     = var.project
  description = "ftptomongo cluster"
  location    = var.location

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

#  master_auth {
#    username = ""
#    password = ""

 #   client_certificate_config {
 #     issue_client_certificate = false
 #   }
 # }
}

# create node pool
resource "google_container_node_pool" "default" {
  name       = "${var.cluster_name}-node-pool"
  project    = var.project
  location   = var.location
  cluster    = google_container_cluster.default.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
