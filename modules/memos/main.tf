resource "azurecaf_name" "random_name_memos" {
  name          = "memos"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}

resource "docker_image" "memos" {
  name         = "neosmemo/memos:stable"
  keep_locally = true
}

resource "docker_volume" "memos_data" {
  name = "memos_data"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_container" "memos" {
  name  = azurecaf_name.random_name_memos.result
  image = docker_image.memos.image_id

  ports {
    internal = 5230
    external = 5230
  }
  networks_advanced {
    name    = var.network_container
    aliases = ["memos"]
  }
  volumes {
    volume_name    = docker_volume.memos_data.name
    container_path = "/var/opt/memos"
  }
  restart = "always"
}
