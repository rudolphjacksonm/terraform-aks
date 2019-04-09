# Create Resource Group
data "azurerm_resource_group" "aks" {
  name     = "${var.resource_group_name}"
}

# Create Azure AD Application for Service Principal
resource "azurerm_azuread_application" "aks_app" {
  name = "${var.name_prefix}-sp"
}

# Create Service Principal
resource "azurerm_azuread_service_principal" "aks_sp" {
  application_id = "${azurerm_azuread_application.aks_app.application_id}"
}

# Generate random string to be used for Service Principal Password
resource "random_string" "password" {
  length  = 32
  special = true
}

# Create Service Principal password
resource "azurerm_azuread_service_principal_password" "aks_pass" {
  end_date             = "2299-12-30T23:00:00Z"                        # Forever
  service_principal_id = "${azurerm_azuread_service_principal.aks_sp.id}"
  value                = "${random_string.password.result}"
}

# Create AKS cluster
resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = "${var.name_prefix}-jenkins1"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "aksjenkinsagent1"

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${azurerm_azuread_application.aks_app.application_id}"
    client_secret = "${azurerm_azuread_service_principal_password.aks_pass.value}"
  }

  tags {
    Environment = "Dev"
  }
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_certificate}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw}"
}

data "azurerm_container_registry" "jmacr" {
  name                = "${var.registry_name}"
  resource_group_name = "${var.resource_group_name}"
}

# manage our docker credentials for gitlab in kubernetes
##resource "kubernetes_secret" "acr_docker_registry" {
#  metadata {
#    name = "docker-registry"
#  }
#
#  data {
#    ".dockercfg" = <<EOF
#{
#  "${data.azurerm_container_registry.jmacr.login_server}": {
#    "username": "${azurerm_azuread_service_principal.aks_sp.id}",
#    "password": "${azurerm_azuread_service_principal_password.aks_pass.value}",
#    "auth": "${base64encode(format("%s:%s", "${azurerm_azuread_service_principal.aks_sp.id}", "$#{azurerm_azuread_service_principal_password.aks_pass.value}"))}"
#  }
#}
#EOF
#  }
#
#  type = "kubernetes.io/dockercfg"
#}

resource "kubernetes_deployment" "jenkins_master" {
  metadata {
    name = "jenkins-master"
    labels {
      app = "jenkins"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels {
          app = "jenkins"
        }
      }

      spec {
        #image_pull_secrets {
        #  name = "${kubernetes_secret.acr_docker_registry.metadata.0.name}"
        #}
        container {
          image = "jenkins/jenkins:lts"
          name  = "jenkins"
        
        port {
          container_port = "8080"
        }
        env {
          name = "JAVA_OPTS"
          value = "-Djenkins.install.runSetupWizard=false"
        }
        resources {
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
        port = 80
        target_port = 8080
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