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

## Provisioning
### 1. Log into the Azure CLI and create a Container Registry -- Azure CLI
Log in to the Azure CLI. This can be done by running `setup.azcli` using bash, zsh, or any shell of your choosing. It can also be run from within VSCode. If you want, you can also copy and paste the commands into the terminal of your choosing.
### 2. Create a Service Principal for use with your AKS Cluster -- Azure CLI + Terraform
This can be done a variety of ways. I'm going to try using Terraform to create the cluster and Azure CLI for anything that has to be done before Terraform is involved. If you want to use Terraform to create your cluster, you have to **precreate** the service principal before creating your cluster. The `setup.azcli` script will do this for us. If you want to use the Azure CLI you can just spin up a cluster on-the-fly and it'll assign one for you (however then you lose out on the nice features Terraform provides).
### 3. Create a custom Jenkins Docker image -- Docker + ACR
We need to create a custom Jenkins image that has the Kubernetes plugin pre-installed. Within in this repository is a `Dockerfile` that contains the necessary config to build the Jenkins image. We want to push this up to our Azure Container Registry.
### 4. Create your cluster -- Terraform
Within this repository, run `terraform init` to ensure you have the AzureRM module installed locally. Then Run `terraform apply` to create your AKS cluster.
### 5. Deploy your services -- Helm/Terraform/Ansible, whichever really!
This part needs to be fleshed out. Helm would be my tool of choice, however Terraform also supports interacting with Kubernetes clusters.