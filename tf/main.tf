# Providers supply resources which can be used within the project
# here, we are using Kubernetes resources
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {

  config_path = "~/.kube/config"
}

# K8s namespaces isolate projects or workloads
resource "kubernetes_namespace" "test" {
  metadata {
    name  = "nginx"
  }
}

# K8s deployments group an application's configuration and dependencies
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  # deployment specifications
  spec {
    replicas = 2
    selector {
      match_labels = {
          app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
            app = "MyTestApp"
        }
      }
      # container specifications
      spec {
        container {
          image     = "nginx"
          name    = "nginx-container"
          port {
              container_port =    80
          }
        }
      }
    }
  }
} # END resource "kubernetes_deployment" "test"

# K8s services manage networking and routing to deployments
resource "kubernetes_service" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30222
      port        = 80
      target_port  = 80
    }
  }
} # END resource "kubernetes_service" "test"
