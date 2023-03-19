terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "codezilla"

    workspaces {
      name = "app"
    }
  }

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.26.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "codezilla" {
  name    = var.k8s_cluster_name
  region  = var.do_region
  version = var.do_k8s_version

  node_pool {
    name       = "worker-pool"
    size       = var.do_k8s_node_size
    node_count = var.do_k8s_node_count
  }
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.codezilla.endpoint
  token = digitalocean_kubernetes_cluster.codezilla.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.codezilla.kube_config[0].cluster_ca_certificate
  )
}

resource "kubernetes_secret" "docker-cfg" {
  metadata {
    name = "docker-cfg"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          "username" = var.registry_username
          "password" = var.gh_token
          "auth"     = base64encode("${var.registry_username}:${var.gh_token}")
        }
      }
    })
  }
}

resource "kubernetes_namespace" "codezilla-ns" {
  metadata {
    name = "codezilla"
  }
}

resource "kubernetes_deployment" "codezilla-deployment" {
  metadata {
    name = "codezilla-deployment"
    namespace = kubernetes_namespace.codezilla-ns.metadata.0.name
    labels = {
      app = "codezilla"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "codezilla"
      }
    }

    template {
      metadata {
        labels = {
          app = "codezilla"
        }
      }

      spec {
        container {
          image = var.app_image
          name  = "codezilla"

          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_role" "pod-reader" {
  metadata {
    name = "pod-reader"
    namespace = kubernetes_namespace.codezilla-ns.metadata.0.name
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "read-pods" {
  metadata {
    name = "read-pods"
    namespace = kubernetes_namespace.codezilla-ns.metadata.0.name
  }

  subject {
    name      = "default"
    kind      = "ServiceAccount"
    namespace = kubernetes_namespace.codezilla-ns.metadata.0.name
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.pod-reader.metadata.0.name
    api_group = "rbac.authorization.k8s.io"
  }
}
