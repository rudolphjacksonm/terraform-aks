### Prerequisites
* Azure CLI
* Docker
* Helm
* Kubernetes
* Terraform

### Foreword -- why I'm bothering with the Azure CLI and not just going straight Terraform
Why are we using a hodge-podge of Azure CLI and Terraform? Why not just go full Terraform? While having a custom Jenkins image is a nice-to-have, it also gives us a reason to muck around with the Azure CLI, learn how to set up a container registry, and push images to it. Once that's done, we can then use Terraform to automate building our cluster and managing things within it. Logging in to Azure with Terraform requires using the CLI anyway, so why we're using it we might as well knock out some small items that could hamstring us later.

*Most importantly*, if we run `terraform destroy` we'll kill our container registry along with it! That certainly wouldn't be nice.

## Provisioning
### 1. Log into the Azure CLI and create a Container Registry -- Azure CLI
Log in to the Azure CLI. This can be done by running `setup.azcli` using bash, zsh, or any shell of your choosing. It can also be run from within VSCode. If you want, you can also copy and paste the commands into the terminal of your choosing.
### 2. Create a custom Jenkins Docker image -- Docker + ACR
We need to create a custom Jenkins image that has the Kubernetes plugin pre-installed. Within in this repository is a `Dockerfile` that contains the necessary config to build the Jenkins image. We want to push this up to our Azure Container Registry.
### 2. Create your cluster -- Terraform
Within this repository, run `terraform init` to ensure you have the AzureRM module installed locally. Then Run `terraform apply` to create your AKS cluster.
### 3. Deploy your services -- Helm/Terraform/Ansible, whichever really!
This part needs to be fleshed out. Helm would be my tool of choice, however Terraform also supports interacting with Kubernetes clusters.