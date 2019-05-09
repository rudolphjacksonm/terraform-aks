
resource "azurerm_resource_group" "tfstates" {
  name                     = "${var.resource_group_name}-${var.env}"
  location                 = "${var.location}"
}

resource "azurerm_storage_account" "main" {
  name                     = "${var.project}${var.env}"
  resource_group_name      = "${azurerm_resource_group.tfstates.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "${var.env}"
  }
}
