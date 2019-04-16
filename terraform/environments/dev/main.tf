locals {
  location                = "UK South"
  resource_group_name     = "jm-aks-rg"
  environment             = "dev"
  prefix                  = "jm"
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

module "service_principal" {
  source                  = "../../modules/service-principal"
  prefix                  = "${local.prefix}"
  environment             = "${local.environment}"
}

#module "dev_aks_cluster" {
#  source                  = "../../modules/aks"
#  name_prefix             = "jm-dev"
#  environment             = "dev"
#  kube_directory          = "/Users/jackmo@kainos.com/.kube"
#  location                = "UK South"
#  resource_group_name     = "jmaksjenkinsuk"
#  failover_location       = "UK West"
#}