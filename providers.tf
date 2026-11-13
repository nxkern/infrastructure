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
  }
}


provider "docker" {
  host = var.host_homelab
}


data "docker_registry_image" "website" {
  name = var.url_image
}


provider "cloudflare" {}
