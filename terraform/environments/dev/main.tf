module "dev_aks_cluster" {
  source                  = "../../modules"
  name_prefix             = "jm-dev"
  environment             = "dev"
  kube_directory          = "/Users/jackmo@kainos.com/.kube"
  location                = "UK South"
  resource_group_name     = "jmaksjenkinsuk"
  failover_location       = "UK West"
}