terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}


data "docker_registry_image" "website" {
  name = var.url_image
}
