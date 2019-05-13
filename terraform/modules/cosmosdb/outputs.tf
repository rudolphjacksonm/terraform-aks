output "cosmosdb_password" {
  value               = "${azurerm_cosmosdb_account.cosmosdb.primary_master_key}"
  sensitive           = true
}

output "cosmosdb_hostname" {
  value               = "${element(split("/", azurerm_cosmosdb_account.cosmosdb.id),8)}.documents.azure.com"
}

output "cosmosdb_user" {
  value               = "${element(split("/", azurerm_cosmosdb_account.cosmosdb.id),8)}"
}