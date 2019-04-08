provider "azurerm" {
  version = "=1.24.0"
}

provider "kubernetes" {
  host = "${base64decode(azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.host)}"

  client_certificate    = "${base64decode(azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_certificate)}"
  client_key            = "${base64decode(azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_key)}"
  client_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_ca_certificate)}"

  version = "=1.5.2"
}