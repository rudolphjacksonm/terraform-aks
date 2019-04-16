# Create resource group for AKS and associated components
resource "azurerm_resource_group" "azurerg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags = {
    environment = "${var.environment}"
  }
}