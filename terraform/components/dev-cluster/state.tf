terraform {
  backend "azurerm" {
    storage_account_name      = "jmbiropstfstates"
    container_name            = "tfstate"
    key                       = "terraform.tfstate"
    access_key                = "ttycMQuXqiH+B3wNOGxI2m8K4v9QuINzX56dypoKhyOoXX48/gF0kLo1tkuUGv6I2+wt+PjlB/9Cqf5fip52Qg=="
  }
}