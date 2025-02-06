# Define the providers that are needed
# These will get installed when "terraform init" is ran
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
   
  }
}


# Defines any properties or configurations for this provider
provider "azurerm" {
  subscription_id = var.subscription_id # true-development
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  features {}
}


provider "helm" {
	kubernetes {
	  config_path = "~/.kube/config"
	}
}