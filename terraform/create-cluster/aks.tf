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