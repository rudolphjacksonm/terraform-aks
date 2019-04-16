# Used for generating the prefix name for the db
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  offer_type                = "Standard"
  kind                      = "MongoDB"

  enable_automatic_failover     = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  # Primary location
  geo_location {
    prefix            = "tfex-cosmos-db-${random_integer.ri.result}-customid"
    location          = "${var.location}"
    failover_priority = 0
  }

  # Failover location
  geo_location {
    location          = "${var.failover_location}"
    failover_priority = 1
  }
}

output "cosmosdb_endpoint" {
  value = "${azurerm_cosmosdb_account.cosmosdb.cosmosdb_endpoint}"
}