# Query resource group
data "azurerm_resource_group" "aks_rg" {
  name = "jmaksjenkinsuk"
}

# Create AKS cluster
resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = "aksjenkins1"
  location            = "${data.azurerm_resource_group.aks_rg.location}"
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
    client_id     = "${var.service_principal["app_id"]}"
    client_secret = "${var.service_principal["client_secret"]}"
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