variable "credentials" {
  default = "./service-account/key-file.json"
}

variable "cluster_name" {
  default = "ftptomongo-cluster"
}

variable "project" {
  default = "smooth-verve-400915"
}

variable "project_id" {
  description = "smooth-verve-400915"
  type        = string
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
  default =  "g1-small" 
}

variable "service_account_name" {
  default = "ftptomongo-sa"
}

variable "service_account_ID" {
  default = ""
}