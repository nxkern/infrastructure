terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    null = {
      source = "hashicorp/null"
      # version = "~> 3.2"
    }

  }
}

