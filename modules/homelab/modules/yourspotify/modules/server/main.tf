resource "docker_image" "server" {
  name         = "yooooomi/your_spotify_server"
  keep_locally = true
}

resource "azurecaf_name" "random_name_server" {
  name          = "server"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod", "your"]
  suffixes      = ["001", "spotify"]
  random_length = 4
  clean_input   = true
}

resource "docker_container" "yourspotify_server" {
  name  = azurecaf_name.random_name_server.result
  image = docker_image.server.image_id
  dns   = ["1.1.1.1", "8.8.8.8"]


  ports {
    internal = 8080
    external = 8081
  }

  networks_advanced {
    name    = var.network_container
    aliases = ["yourspotify_server"]
  }
  env = [
    "API_ENDPOINT=${var.api_endpoint}",
    "CLIENT_ENDPOINT=${var.client_endpoint}",
    "SPOTIFY_PUBLIC=${var.spotify_public}",
    "SPOTIFY_SECRET=${var.spotify_secret}",
    "MONGO_ENDPOINT=mongodb://${var.mongo_ip}:27017/your_spotify",
    "NODE_OPTIONS=--dns-result-order=ipv4first --no-network-family-autoselection",
  ]

  depends_on = [var.mongo_module]
  restart    = "unless-stopped"
}
