#resource "kubernetes_deployment" "jenkins_master" {
#  metadata {
#    name = "jenkins-master"
#    labels {
#      app = "jenkins"
#    }
#  }
#
#  spec {
#    replicas = 1
#
#    selector {
#      match_labels {
#        app = "jenkins"
#      }
#    }
#
#    template {
#      metadata {
#        labels {
#          app = "jenkins"
#        }
#      }
#
#      spec {
#        #image_pull_secrets {
#        #  name = "${kubernetes_secret.acr_docker_registry.metadata.0.name}"
#        #}
#        container {
#          image = "jenkins/jenkins:lts"
#          name  = "jenkins"
#        
#        port {
#          container_port = "8080"
#        }
#        env {
#          name = "JAVA_OPTS"
#          value = "-Djenkins.install.runSetupWizard=false"
#        }
#        resources {
#            limits{
#              cpu    = "0.5"
#              memory = "512Mi"
#            }
#            requests{
#              cpu    = "250m"
#              memory = "50Mi"
#            }
#          }
#        }
#      }
#    }
#  }
#}
#
#resource "kubernetes_service" "jenkins_service" {
#  metadata {
#    name = "jenkins-service"
#  }
#
#  spec {
#    selector {
#      app = "${kubernetes_deployment.jenkins_master.metadata.0.labels.app}"
#    }
#    
#    session_affinity = "ClientIP"
#    port {
#        port = 80
#        target_port = 8080
#    }
#
#      type = "LoadBalancer"
#  }
#}
#
#resource "kubernetes_role_binding" "jenkins-rbac" {
#  metadata {
#    name = "jenkins-rbac"
#  }
#
#  role_ref {
#    kind = "ClusterRole"
#    name = "cluster-admin"
#    apigroup = "rbac.authorization.k8s.io"
#  }
#
#  subject {
#    kind = "ServiceAccount"
#    name = "default"
#    namespace = "default"
#  }
#
#}