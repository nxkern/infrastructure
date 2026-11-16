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
  }
}


provider "docker" {
  host = var.host_homelab
}

provider "cloudflare" {}
