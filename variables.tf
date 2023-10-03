variable "credentials" {
  default = "../service-account/zango-terra.json"
}

variable "cluster_name" {
  default = "zango-cluster-go"
}

variable "project" {
  default = ""
}

variable "location" {
  default = "europe-central2"
}

variable "zone" {
  default = "europe-central2-a"
}

variable "initial_node_count" {
  default = 1
}

variable "machine_type" {
  default =  "f1-micro" 
}

variable "service_account_name" {
  default = "zango-terra"
}