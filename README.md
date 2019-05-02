### Prerequisites
* Azure CLI
* Docker
* Helm
* Kubernetes
* Terraform
* The helm-secrets plugin (for encrypting and decrypting secrets files)
* `gpg` for creating PGP keys

### NOTE: AzureRM Provider for Terraform
The AzureRM provider is pinned to version `1.24` at the moment. When version `2.0` is released it will bring breaking changes to the way Service Principals are created. There is a guide for migrating to the new version [here](https://www.terraform.io/docs/providers/azurerm/guides/migrating-to-azuread.html).

## Provisioning - the Hard Way, but the Right Way
This is lifted from an amazing blog post over at [kubernauts.io](https://blog.kubernauts.io/aks-deployment-automation-with-terraform-and-multi-aks-cluster-management-with-rancher-6da9865ad52b).
### 1. Create an Azure Storage Account -- Azure CLI
The Why: We need to create an Azure Storage Account to store our `.tfstate` files. This can be done on Jenkins or locally; either way it'll have to be up and running before you can start using Terraform properly with a remote state. You *could* use S3, but then you'd be storing your `.tfstate` files in a separate cloud provider which is a bit nonsensical.

The How: Log in to the Azure CLI. This can be done by running `create_storage_account.azcli` using bash, zsh, or any shell of your choosing. It can also be run from within VSCode.
### 2. Setup your Terraform Backend
This part is pretty self-explanatory if you're familiar with Terraform. Update the `state.tf` file in the `terraform` directory to point to your storage container.
### 3. Create your cluster -- Terraform
Change into the `terraform/create-cluster` directory and run `terraform init` to ensure you have the AzureRM module installed locally. Then run `terraform apply` to create your AKS cluster.
### 4. Deploy your services -- Helm
1. Run `az aks get-credentials`
2. Run `helm init` to install Helm and Tiller into your cluster
3. Label the deployment namespace so cert-manager will NOT validate resources: `kubectl label namespace default certmanager.k8s.io/disable-validation="true"`
4. Install the CRDs into the cluster to support `cert-manager`: `kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml`
5. Update the relevant secrets files with the credentials for your cloud services
6. Decrypt the secrets files using `helm secrets`
7. Run `helm install . -f ../helm-environments/dev/values.yaml`

## Updating this repository
Updating this repository should be as painless as possible. Currently I can't find a way to get the `helm secrets` plugin to automatically decrypt and apply secrets when running all of the charts. For now I'm manually encrypting files with my PGP key and uploading them to GitHub. Whenever I want to install these charts I'm decrypting the files with the same key, overwriting the encrypted version with the decrypted `.yaml.dec` file, then running `helm install`.


##### Notes
* Going to try using the helm secrets plugin to encrypt secrets files.
* I've moved helm charts that I'm no longer using or am in the process of replacing to the `backup` folder.
* You can pass values to dependent charts mentioned in your `requirements.yaml` using this format:
```
Dependent-chart-name (must match name field in requirements.yaml):
  spec:
    replicas: 3
```
Here's another example:
```
nginx-ingress:
  controller:
    service:
        annotations:
          service.beta.kubernetes.io/azure-dns-label-name: jm-aks
```
* You need to run `helm dep up` to get the nginx-ingress chart specified in `requirements.yaml` before you can run `helm install`