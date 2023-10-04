variable "credentials" {
  default = "../service-account/ftptomongo_sa.json"
}

variable "cluster_name" {
  default = "ftptomongo-cluster"
}

variable "project" {
  default = "pr-ftptomongo"
}

variable "location" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "initial_node_count" {
  default = 1
}

variable "machine_type" {
  default =  "f1-micro" 
}

variable "service_account_name" {
  default = "ftptomongo-sa"
}