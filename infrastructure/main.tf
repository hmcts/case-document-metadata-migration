locals {
  common_tags {
    "Deployment Environment"  = "${var.env}"
    "Team Contact"            = "${var.team_contact}"
    "Destroy Me"              = "${var.destroy_me}"
  }

  storage_account_tags {
    "Team Name" = "${var.team_name}"
  }

  tags = "${merge(local.common_tags, local.storage_account_tags)}"
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name      = "${var.product}-${var.env}-rg"
  location  = "${var.location}"
  tags      = "${local.tags}"
}

# Create Key Vault
module "rd_key_vault" {
  source                      = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                        = "${var.product}-${var.env}"
  location                    = "${var.location}"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  tenant_id                   = "${var.tenant_id}"
  object_id                   = "${var.jenkins_AAD_objectId}"
  product_group_object_id     = "${var.product_group_object_id}"
  env                         = "${var.env}"
  product                     = "${var.product}"
  common_tags                 = "${local.tags}"

  # AKS Migration
  managed_identity_object_id  = "${var.managed_identity_object_id}"
}

# Create Storage Account
module "storage_account" {
  source                    = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  storage_account_name      = "${replace("${var.product}${var.env}", "-", "")}"
  env                       = "${var.env}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_kind              = "BlobStorage"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true

  # Tags
  common_tags   = "${local.storage_account_tags}"
  team_contact  = "${var.team_contact}"
  destroy_me    = "${var.destroy_me}"
  sa_subnets    = ["${data.azurerm_subnet.aks-01.id}", "${data.azurerm_subnet.aks-00.id}", "${data.azurerm_subnet.jenkins_subnet.id}"]
}