module "dev_resource_group" {
  source                  = "../../modules/resource-group"
  environment             = "${var.environment}"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
}

module "dev_cosmosdb" {
  source                  = "../../modules/cosmosdb"
  failover_location       = "UK West"
  location                = "${var.location}"
  name                    = "${var.prefix}-${var.environment}-cosmosdb-account"
  resource_group_name     = "${module.dev_resource_group.resource_group_name}"
}

module "dev_aks_cluster" {
  source                  = "../../modules/aks"
  prefix                  = "${var.prefix}"
  environment             = "${var.environment}"
  location                = "${var.location}"
  resource_group_name     = "${module.dev_resource_group.resource_group_name}"
  node_count              = "${var.node_count}"
}

module "dev_mysql_server" {
  source                  = "../../modules/azmysql"
  prefix                  = "${var.prefix}"
  environment             = "${var.environment}"
  location                = "${var.location}"
  resource_group_name     = "${module.dev_resource_group.resource_group_name}"
  # Passing this so there is an explicit dependency on the cluster being created first
  aks_cluster_name        = "${module.dev_aks_cluster.aks_cluster_name}"
}

output "dev_mysql_server_password" {
  value = "${module.dev_mysql_server.mysql_password}"
}

output "dev_cosmosdb_password" {
  value = "${module.dev_cosmosdb.cosmosdb_password}"
}