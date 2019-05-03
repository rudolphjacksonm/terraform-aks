resource "random_string" "mysqladmin_password" {
  length           = 12
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!#%*()-_=+[]{}<>"
}

resource "azurerm_mysql_server" "test" {
  name                = "jm-aks-mysql"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  sku {
    name     = "B_Gen5_1"
    capacity = 1
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "mysqladmin"
  administrator_login_password = "${random_string.mysqladmin_password.result}"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mysql_database" "socksdb" {
  name                = "socksdb"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.test.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

output "mysql_password" {
  value = "${random_string.mysqladmin_password.result}"
}

output "mysql_hostname" {
  value = "${azurerm_mysql_server.test.fqdn}"
}
