# Set default name prefix
variable "name_prefix" {
  default = "aks-jm"
}

variable "kube_directory" {
  default = "/Users/jackmo@kainos.com/.kube"
}

# Set default location
variable "location" {
  default = "UK South"
}

# This should match what is listed in setup.azcli
variable "resource_group_name" {
  default = "jmaksjenkinsuk"
}

# These values are provided in the stdout when creating a service principal using az cli
variable "service_principal" {
  type = "map"
  default = {
    app_id = "01187ef1-43fc-4b9a-a804-941dce7b470a"
    client_secret = "2f0e6ef4-a81e-405b-be2e-12c2173fc9da"
  }
}