module "dev" {
  source = "environments/dev"
}

output "dev_mysql_password" {
  value = "${module.dev.dev_mysql_server_password}"
}

output "dev_cosmosdb_password" {
  value = "${module.dev.dev_cosmosdb_password}"
}