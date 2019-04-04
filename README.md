### Prerequisites
* Terraform
* Azure CLI
* Kubernetes

### Provisioning
1. Log in to the Azure CLI. This can be done by running the login.azcli file from within VSCode or by running the commands in the terminal of your choosing.
2. Run `terraform init` to ensure you have the AzureRM module installed locally.
3. Run `terraform apply` to create your AKS cluster