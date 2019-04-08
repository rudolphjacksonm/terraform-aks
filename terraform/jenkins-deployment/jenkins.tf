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
