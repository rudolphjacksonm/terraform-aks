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

module "cosmosdb" {
  source                  = "../../modules/cosmosdb"
  failover_location       = "UK West"
  location                = "${local.location}"
  name                    = "${local.prefix}-${local.environment}-cosmosdb-account"
  resource_group_name     = "${local.resource_group_name}"
}

module "dev_aks_cluster" {
  source                  = "../../modules/aks"
  prefix                  = "jm"
  environment             = "dev"
  location                = "UK South"
  resource_group_name     = "${local.resource_group_name}"
  node_count              = "${local.node_count}"
}