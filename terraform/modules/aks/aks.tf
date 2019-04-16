# Create Service Principal for AKS cluster
module "service_principal" {
  source                  = "../service-principal"
  prefix                  = "${var.prefix}"
  environment             = "${var.environment}"
}

# Create AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${var.prefix}-aks-${var.environment}"
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
    client_id     = "${module.service_principal.service_principal_client_id}"
    client_secret = "${module.service_principal.service_principal_client_secret}"
  }

  tags {
    Environment = "${var.environment}"
  }
}