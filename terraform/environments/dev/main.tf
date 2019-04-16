module "dev_aks_cluster" {
  source                  = "../../modules"
  name_prefix             = "jm-dev"
  kube_directory          = "/Users/jackmo@kainos.com/.kube"
  location                = "UK South"
  resource_group_name     = "jmaksjenkinsuk"
  service_principal {
    app_id = ""
    client_secret = ""
  }
}