terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.27.0"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}
