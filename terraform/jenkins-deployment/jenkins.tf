data "azurerm_container_registry" "jmacr" {
  name                = "${var.registry_name}"
  resource_group_name = "${var.resource_group_name}"
}

resource "kubernetes_deployment" "jenkins_master" {
  metadata {
    name = "jenkins-master"
    labels {
      role = "jenkins"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        role = "jenkins"
      }
    }

    template {
      metadata {
        labels {
          role = "jenkins"
        }
      }

      spec {
        container {
          image = "${data.azurerm_container_registry.jmacr.login_server}/${var.image_name}"
          name  = "jenkins"
        
        port {
          container_port = "8080"
        }

          resources{
            limits{
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests{
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins_service" {
  metadata {
    name = "jenkins-service"
  }

  spec {
    selector {
      app = "${kubernetes_deployment.jenkins_master.metadata.0.labels.app}"
    }
    
    session_affinity = "ClientIP"
    port {
        port = 8080
        target_port = 80
    }

      type = "LoadBalancer"
  }
}

resource "kubernetes_role_binding" "jenkins-rbac" {
  metadata {
    name = "jenkins-rbac"
  }

  role_ref {
    kind = "ClusterRole"
    name = "cluster-admin"
    apigroup = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "default"
    namespace = "default"
  }

}