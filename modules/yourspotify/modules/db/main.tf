resource "docker_image" "mongo_yourspotify" {
  name         = "mongo:4.4"
  keep_locally = true
}

resource "docker_volume" "mongo_db" {
  name = "mongo_db"
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurecaf_name" "random_name_mongo" {
  name          = "mongo_yourspotify"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod", "your"]
  suffixes      = ["001", "spotify"]
  random_length = 4
  clean_input   = true
}

resource "docker_container" "mongo_yourspotify" {
  name  = azurecaf_name.random_name_mongo.result
  image = docker_image.mongo_yourspotify.image_id

  networks_advanced {
    name    = var.network_container
    aliases = ["mongo"]
  }

  volumes {
    volume_name    = docker_volume.mongo_db.name
    container_path = "/data/db"
  }
  restart = "always"
}
