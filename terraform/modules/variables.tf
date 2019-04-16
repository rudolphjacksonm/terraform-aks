# Set default name prefix
variable "name_prefix" {}

variable "kube_directory" {}

# Set default location
variable "location" {}

# This should match what is listed in setup.azcli
variable "resource_group_name" {}

# These values are provided in the stdout when creating a service principal using az cli
variable "service_principal" {}

variable "registry_name" {}

variable "image_name" {}