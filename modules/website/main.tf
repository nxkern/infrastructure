resource "docker_image" "website" {
  name          = data.docker_registry_image.website.name
  pull_triggers = [data.docker_registry_image.website.sha256_digest]
  keep_locally  = true
}

resource "azurecaf_name" "random_name_website" {
  name          = "website"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod", "web"]
  suffixes      = ["001", "site"]
  random_length = 4
  clean_input   = true
}

resource "docker_container" "website" {
  name  = azurecaf_name.random_name_website.result
  image = docker_image.website.image_id

  ports {
    internal = 3000
    external = 3010
  }
  host {
    host = var.worker_host
    ip   = var.ip_worker
  }
  networks_advanced {
    name    = var.network_container
    aliases = ["website"]
  }
  env = [
    "NUXT_API_KEY_WORKER=${var.nuxt_api_key_worker}",

  ]
  restart = "always"
}
