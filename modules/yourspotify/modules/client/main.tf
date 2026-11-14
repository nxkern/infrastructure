resource "docker_image" "client" {
  name         = "yooooomi/your_spotify_client"
  keep_locally = true
}

resource "azurecaf_name" "random_name_client" {
  name          = "client"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod", "your"]
  suffixes      = ["001", "spotify"]
  random_length = 4
  clean_input   = true
}

resource "docker_container" "yourspotify_client" {
  name  = azurecaf_name.random_name_client.result
  image = docker_image.client.image_id

  ports {
    internal = 3000
    external = 3001
  }

  networks_advanced {
    name    = var.network_container
    aliases = ["yourspotify_client"]
  }

  env = [
    "API_ENDPOINT=${var.api_endpoint}",
  ]
  restart = "always"
}
