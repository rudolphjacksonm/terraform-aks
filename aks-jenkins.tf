resource "azurerm_resource_group" "rg1" {
  name     = "aksRG1"
  location = "UK South"
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = "aksjenkins1"
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  dns_prefix          = "aksjenkinsagent1"

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "00000000-0000-0000-0000-000000000000"
    client_secret = "00000000000000000000000000000000"
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