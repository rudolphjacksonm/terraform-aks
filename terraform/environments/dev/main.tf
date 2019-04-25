locals {
  location                = "UK South"
  resource_group_name     = "jm-aks-rg"
  environment             = "dev"
  prefix                  = "jm"
  node_count              = "2"
}
module "dev_resource_group" {
  source                  = "../../modules/resource-group"
  environment             = "${local.environment}"
  location                = "${local.location}"
  resource_group_name     = "${local.resource_group_name}"
}

module "dev_cosmosdb" {
  source                  = "../../modules/cosmosdb"
  failover_location       = "UK West"
  location                = "${local.location}"
  name                    = "${local.prefix}-${local.environment}-cosmosdb-account"
  resource_group_name     = "${module.dev_resource_group.resource_group_name}"
}

module "dev_aks_cluster" {
  source                  = "../../modules/aks"
  prefix                  = "${local.prefix}"
  environment             = "${local.environment}"
  location                = "${local.location}"
  resource_group_name     = "${module.dev_resource_group.resource_group_name}"
  node_count              = "${local.node_count}"
}

module "dev_mysql_server" {
  source                  = "../../modules/azmysql"
  prefix                  = "${local.prefix}"
  environment             = "${local.environment}"
  location                = "${local.location}"
  resource_group_name     = "${module.dev_resource_group.resource_group_name}"
  # Passing this so there is an explicit dependency on the cluster being created first
  aks_cluster_name        = "${module.dev_aks_cluster.aks_cluster_name}"
}