# Backend configuration
Use the backend partial configs stored in `../backends/config/${ENV}` when running `terraform init` on any of the components in the component directory.

Then, when running `terraform apply` you can simply pass variables to the component, as the backend configuration has been stored in the remote state.
`terraform apply -var-file=../../environments/dev/dev.tfvars`