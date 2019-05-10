output "cosmosdb_password" {
  value               = "${azurerm_cosmosdb_account.cosmosdb.primary_master_key}"
  sensitive           = true
}