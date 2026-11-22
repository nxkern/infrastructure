terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    null = {
      source = "hashicorp/null"
      # version = "~> 3.2"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "5.14.0"
    }
  }
}


provider "docker" {
  host = var.host_homelab
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "azurerm" {
  features {}
}


data "cloudflare_zone" "nxbin" {
  filter = {
    name = "nxbin.xyz"
  }
}

