provider "google" {
  project = var.project
  region  = var.location
  credentials = var.credentials
  zone    = var.zone
}

resource "google_container_cluster" "ftptomongo_cluster" {
  name        = var.cluster_name
  project     = var.project
  description = "ftptomongo-cluster"
  location    = var.location

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
   # Add the deletion_protection block to disable deletion protection
  deletion_protection = false
}

resource "google_container_node_pool" "ftptomongo_node_pool" {
  name       = "ftptomongo-node-pool"
  location   = var.location
  cluster    = google_container_cluster.ftptomongo_cluster.name
  node_count = 1

  node_config {
    machine_type = "n1-standard-1"
  }
}


resource "null_resource" "update_k8s_settings" {
  depends_on = [google_container_cluster.ftptomongo_cluster]

  #change ";" (for Windows) to "&&" for UNIX
  provisioner "local-exec" {
    command = <<-EOT
      gcloud container clusters get-credentials ftptomongo-cluster --zone=europe-west4 ; 
      kubectl config use-context gke_smooth-verve-400915_europe-west4_ftptomongo-cluster
    EOT
  }
}
locals {
  passive_ports_list = range(51100, 52100)
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}



resource "kubernetes_deployment" "ftptomongo_pod" {
  metadata {
    name = "ftptomongo-pod"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ftptomongo"
      }
    }

    template {
      metadata {
        labels = {
          app = "ftptomongo"
        }
      }

      spec {
        container {
          name  = "ftptomongo-container"
          image = "gcr.io/smooth-verve-400915/nill2/ftptomongo:latest"

          port {
            container_port = 2121
          }
          dynamic "port" {
            for_each = local.passive_ports_list

            content {
              container_port        = port.value
            }
          }


          volume_mount {
            name      = "ftp-data-volume"
            mount_path = "/app/ftp"
          }

          env {
            name  = "PASSIVE_PORT_RANGE"
            value = "52000-52050"
          }
        }
        volume {
            name = "ftp-data-volume"

            empty_dir {}
        }
      }
    }
  }
}

#variable "passive_ports" {}



resource "kubernetes_service" "ftptomongo_service" {
  metadata {
    name = "ftptomongo-service"
  }


  spec {
    selector = {
      app = kubernetes_deployment.ftptomongo_pod.spec[0].template[0].metadata[0].labels.app
    }

    port {
      name = "2121"
      port        = 2121
      target_port = kubernetes_deployment.ftptomongo_pod.spec[0].template[0].spec[0].container[0].port[0].container_port
    }

    dynamic "port" {
      for_each = local.passive_ports_list

      content {
        name       = "port-${port.value}"
        port        = port.value
        target_port = port.value
      }
    }

    type = "LoadBalancer"
  }
}

resource "google_project_iam_member" "ftptomongo_cluster_iam" {
  project = var.project
  role    = "roles/container.clusterViewer"
  member  = "user:danil.d.kabanov@gmail.com" 
}


resource "google_compute_firewall" "ftptomongo_firewall" {
  name    = "ftptomongo-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2121", "52000-52050"]
  }

  source_ranges = ["0.0.0.0/0"]
}

