module "dev_aks_cluster" {
  source                  = "../../modules"
  name_prefix             = "jm-dev"
  kube_directory          = "/Users/jackmo@kainos.com/.kube"
  location                = "UK South"
  resource_group_name     = "jmaksjenkinsuk"
  service_principal {
    app_id = "01187ef1-43fc-4b9a-a804-941dce7b470a"
    client_secret = "2f0e6ef4-a81e-405b-be2e-12c2173fc9da"
  }
}