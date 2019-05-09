# Backend configuration
Use the backend partial configs stored in `../backends/config/${ENV}` when applying any of the components in the component directory.

`terraform apply -backend-config=../../backends/config/dev/dev.backend.config`