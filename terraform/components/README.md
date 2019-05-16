# Backend configuration
Use the backend partial configs stored in `../backends/config/${ENV}` when running `terraform init` on any of the components in the component directory.

# Service Principals and access to Azure storage accounts
Service Principals in Azure can be treated similarly to IAM roles in AWs. We create an application in Azure AD and then a corresponding Service Principal. This will be the role that our CI/CD system will use to deploy clusters and create resources, as well as our storage account where we will store all of our `.tfstate` files.

# Process Flow
- Create Azure AD application + service principal (Using Service Principal credentials)
- Create backend
- Create cluster, store state in backend referenced above (no need for access key as service principal will have access to storage account)

Then, when running `terraform apply` you can simply pass variables to the component, as the backend configuration has been stored in the remote state.
`terraform apply -var-file=../../environments/dev/dev.tfvars`
