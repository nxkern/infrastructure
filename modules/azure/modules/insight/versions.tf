terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "5.14.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}

