output "mysql_password" {
  value = "${random_string.mysqladmin_password.result}"
  sensitive = true
}

output "mysql_fqdn" {
  value = "${azurerm_mysql_server.test.fqdn}"
  sensitive = true
}