provider "azurerm" {
  version = "=1.44.0"
}

provider "azurerm" {
  alias           = "aks-infra"
  subscription_id = "${var.aks_infra_subscription_id}"
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = "${var.mgmt_subscription_id}"
}

terraform {
  backend "azurerm" {}
}