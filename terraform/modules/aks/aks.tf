# Create Service Principal for AKS cluster
module "aks" {
  source                  = "../../modules/aks"
  prefix                  = "${local.prefix}"
  environment             = "${local.environment}"
  location                = "${local.location}"
  resource_group_name     = "${local.resource_group_name}"
}

# Create AKS cluster
resource "azurerm_kubernetes_cluster" "k8s_cluster" {
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
    client_id     = "${module.aks.service_principal_client_id}"
    client_secret = "${module.aks.service_principal_client_secret}"
  }

  tags {
    Environment = "${var.environment}"
  }
}