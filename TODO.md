### Not started
* Fix readiness/liveness probes
* Move connection string details to k8s secret
* Update Terraform to create Azure Cache for Redis
* Update Terraform to create Queues
* Connect Session app to Azure Cache for Redis
* Replace RabbitMQ app with Azure Queues
### WIP
* Connect User app to CosmosDB
* Upgrade AKS cluster size, currently too small to run all pods
### Done
* Update Terraform to create CosmosDB
* Connect Carts app to CosmosDB
* [NOT SUPPORTED] Set reserved throughput on CosmosDB collections to lowest value to save on $$$