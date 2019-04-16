terraform {
  backend "azurerm" {
    storage_account_name      = "jmbiropstfstates"
    container_name            = "tfstate"
    key                       = "terraform.tfstate"
  }
}