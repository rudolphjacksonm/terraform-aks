# Backends
Use this directory to do the following:
1. Create resource groups and storage accounts for use by components later on using Terraform
2. Store backend configs to be used when running `terraform init` for base components, application components, etc etc: 
```
terraform init -backend-config=../../backends/config/${ENV}/${ENV}.backend.config
```

## Prereqs
You'll need:
- An Azure AD Application + Service Principal
- The credentials for your Service Principal

Set the credentials as environment variables before proceeding with the steps outlined below:
```
export ARM_CLIENT_ID=00000-000000-000000-00000
export ARM_CLIENT_SECRET=<sensitive>
export ARM_TENANT_ID=00000-000000-000000-00000
export ARM_SUBSCRIPTION_ID=00000-000000-000000-00000
```

## Creating new backends
To enable us to move quickly, do the following:
1. Create a new backend configuration in the `backends/config/dev` folder. This should only contain the following:
```
storage_account_name      = "sockshoptfstates"
container_name            = "tfstates"
key                       = "jmterraform.tfstate"
resource_group_name       = "sockshop-tfstates"
```
2. Create a `.tfvars` file for the environment you want to deploy and store it in the `environments` folder, e.g. `environments/dev/dev.tfvars`. When you create the backend, the values in the backend configuration are combined with the variables in your `.tfvars` file, so things like the project name, location, and environment will populate the resource group and storage account names for you. This means you can reuse the backend config along with different tfvar files to create as many backends as you like in the same account--the only caveat being that you must delete the .tfstate file locally before supplying a new `.tfvar` file.
  ```
  location                = "UK South"
  resource_group_name     = "sockshop-dev-rg"
  environment             = "dev"
  prefix                  = "jm"
  node_count              = "2"
  project                 = "sockshop"
  env                     = "dev"
  ```
3. Run `terraform init -var-file=config/dev/backend_dev_base.tfvars.example -var-file=../environments/dev/dev.tfvars`. This will verify your backend configuration and install the AzureRM provider if it has not been installed yet.
4. Run `terraform apply -var-file=config/dev/backend_dev_base.tfvars.example -var-file=../environments/dev/dev.tfvars` to create the backend, which will consist of:
- An Azure Resource Group
- An Azure Storage Account

You now have a valid backend configuration using an Azure Storage Account. This can be used when applying any of the components by running the following: 
```
terraform init -backend-config=../../backends/config/dev/dev.backend.config
```

Using an Azure Service Principal:
```
export ARM_CLIENT_ID=00000-000000-000000-00000
export ARM_CLIENT_SECRET=<sensitive>
export ARM_TENANT_ID=00000-000000-000000-00000
export ARM_SUBSCRIPTION_ID=00000-000000-000000-00000
terraform init -backend-config=../../backends/config/dev/dev.backend.config
```

Then, when you are ready to start building your infrastructure you can simply run `terraform apply -var-file=../../environments/dev/dev.tfvars`.
