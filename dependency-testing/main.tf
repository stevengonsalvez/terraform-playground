/*
Provider Definitions
*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.76.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}


variable "test" {
  default = false
}

module "regions" {
  source       = "claranet/regions/azurerm"
  version      = "4.1.0"
  azure_region = "eu-north"
}


locals {
    resource_group_name = "terraform-test-s"


}

resource "azurerm_resource_group" "this" {
  count = var.test ? 1 : 0
  name     = local.resource_group_name
  location = module.regions.location_cli
  tags = {
    "Name" = local.resource_group_name
  }
}

resource "azurerm_resource_group" "now" {
  name     = "${local.resource_group_name}-now"
  location = module.regions.location_cli
  tags = {
    "Name" = local.resource_group_name
  }
}


resource "azurerm_app_configuration" "appconf" {
  name                = "appConf1-1123"
  resource_group_name = "terraform-test-s-now"
  location            = module.regions.location_cli
  depends_on = [
    azurerm_resource_group.this,
    azurerm_resource_group.now
  ]
}