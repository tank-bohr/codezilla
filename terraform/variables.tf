variable "do_token" {
  description = "Tells Terraform to seek your DigitalOcean API token upon deployment so it can access your DigitalOcean account and deploy resources via the API."
  type        = string
  sensitive   = true
}

variable "gh_token" {
  description = "Token for GH container registry access"
  type        = string
  sensitive   = true
}

variable "do_region" {
  # https://docs.digitalocean.com/products/platform/availability-matrix/
  description = "region slug"
  type        = string
  default     = "fra1"
}

variable "do_k8s_version" {
  description = "Grab the latest version slug from `doctl kubernetes options versions`"
  type        = string
  default     = "1.27.2-do.0"
}

variable "do_k8s_node_size" {
  # https://docs.digitalocean.com/products/kubernetes/#allocatable-memory
  description = "Size of DO k8s node"
  type        = string
  default     = "s-2vcpu-2gb"
}

variable "do_k8s_node_count" {
  description = "Number of nodes of the cluster"
  type        = number
  default     = 3
}

variable "k8s_cluster_name" {
  description = "The name of the k8s cluster"
  type        = string
  default     = "codezilla"
}

variable "registry_server" {
  description = "Docker container registry server"
  type        = string
  default     = "ghcr.io"
}

variable "registry_username" {
  description = "Docker container registry username to auth"
  type        = string
  default     = "terraform"
}
