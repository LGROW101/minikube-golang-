terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "my_go_app" {
  metadata {
    name = "my-go-app"
    labels = {
      app = "my-go-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-go-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-go-app"
        }
      }

      spec {
        container {
          image = "my-go-app:v1"
          name  = "my-go-app"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my_go_app" {
  metadata {
    name = "my-go-app"
  }

  spec {
    selector = {
      app = "my-go-app"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "NodePort"
  }
}
