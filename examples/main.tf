## main.tf terraform configuration
#
terraform {
  required_version = ">= 1.9.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.57.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "myorg"
    workspaces {
      name = "my-workspace"
    }
  }
}

provider "azurerm" {
  features {}
}
