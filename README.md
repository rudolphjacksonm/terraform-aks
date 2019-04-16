### Prerequisites
* Azure CLI
* Docker
* Helm
* Kubernetes
* Terraform

### NOTE: AzureRM Provider for Terraform
The AzureRM provider is pinned to version `1.24` at the moment. When version `2.0` is released it will bring breaking changes to the way Service Principals are created. There is a guide for migrating to the new version [here](https://www.terraform.io/docs/providers/azurerm/guides/migrating-to-azuread.html).

### Foreword -- why I'm bothering with the Azure CLI and not just going straight Terraform
Why are we using a hodge-podge of Azure CLI and Terraform? Why not just go full Terraform? While having a custom Jenkins image is a nice-to-have, it also gives us a reason to muck around with the Azure CLI, learn how to set up a container registry, and push images to it. Once that's done, we can then use Terraform to automate building our cluster and managing things within it. Logging in to Azure with Terraform requires using the CLI anyway, so why we're using it we might as well knock out some small items that could hamstring us later.

*Most importantly*, if we run `terraform destroy` we'll kill our container registry along with it! That certainly wouldn't be nice.

## Provisioning - the Hard Way, but the Right Way
This is lifted from an amazing blog post over at [kubernauts.io](https://blog.kubernauts.io/aks-deployment-automation-with-terraform-and-multi-aks-cluster-management-with-rancher-6da9865ad52b).
### 1. Create an Azure Storage Account -- Azure CLI
The Why: We need to create an Azure Storage Account to store our `.tfstate` files. This can be done on Jenkins or locally; either way it'll have to be up and running before you can start using Terraform properly with a remote state. You *could* use S3, but then you'd be storing your `.tfstate` files in a separate cloud provider which is a bit nonsensical.

The How: Log in to the Azure CLI. This can be done by running `create_storage_account.azcli` using bash, zsh, or any shell of your choosing. It can also be run from within VSCode.
### 2. Setup your Terraform Backend
This part is pretty self-explanatory if you're familiar with Terraform. Update the `state.tf` file in the `terraform` directory to point to your storage container.
### 3. Create a Service Principal for use with your AKS Cluster --Terraform
This can be done a variety of ways. I found an example of using the AzureRM provider to create the service principal before making the cluster, so it's pure Terraform after doing the container registry creation. If you want to see how it works with the AzureCLI uncomment the service principal section.
### 4. Create your cluster -- Terraform
Change into the `terraform/create-cluster` directory and run `terraform init` to ensure you have the AzureRM module installed locally. Then, set the following environment variables:
```
$ export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
$ export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
$ export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
$ export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```
 Then run `terraform apply` to create your AKS cluster.
### 5. Deploy your services -- Terraform
1. Run `terraform output kube_config > ~/.kube/azurek8s`
2. Run `export KUBECONFIG=~/.kube/azurek8s` before running this or you will not be able to connect to your cluster using Terraform.
3. Change into the `terraform/jenkins-deployment` directory and run `terraform init` to ensure you have the Kubernetes module installed locally. Then run `terraform apply` to deploy Jenkins along with the necessary k8s service and RBAC role binding.