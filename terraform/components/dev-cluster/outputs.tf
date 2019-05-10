output "mysql_password" {
  value     = "${module.dev_mysql_server.mysql_password}"
  sensitive = true
}

output "mysql_fqdn" {
  value     = "${module.dev_mysql_server.mysql_fqdn}"
  sensitive = true
}

output "cosmosdb_password" {
  value     = "${module.dev_cosmosdb.cosmosdb_password}"
  sensitive = true
}