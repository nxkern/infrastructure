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

data "docker_registry_image" "quickqr-api" {
  name = var.url_image
}
