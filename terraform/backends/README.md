# Backends
Use this directory to do the following:
1. Create resource groups and storage accounts for use by components later on using Terraform
2. Store backend configs to be used when running `terraform init` for base components, application components, etc etc: 
```
terraform init \
-backend-config=../../backends/config/${ENV}/${ENV}.backend.config
```

## Creating new backends
To enable us to move quickly, do the following:
1. Create a new backend configuration in the `backends/config/dev` folder. This should only contain the following:
```
storage_account_name      = "myazurestorageaccount"
container_name            = "tfstates"
key                       = "terraform.tfstate"
access_key                = ""
```
2. Create a `tfvars` file for the environment you want to deploy. This will contain all sorts of useful bits that are important for customizing your environment, like your resource group name, the name of your project, the environment (e.g. dev, stg, prod), and the location in Azure where you wish to deploy.
3. Run `terraform init -var-file=config/dev/dev.backend.config -var-file=../environments/dev/dev.tfvars`. This will verify your backend configuration install the AzureRM provider if it has not been installed yet.
4. Run `terraform apply -var-file=config/dev/dev.backend.config -var-file=../environments/dev/dev.tfvars` to create the backend, which will consist of:
- An Azure Resource Group
- An Azure Storage Account

You now have a valid backend configuration using an Azure Storage Account. This can be used when applying any of the components by running the following: `terraform init -backend-config=../../backends/config/dev/dev.backend.config`