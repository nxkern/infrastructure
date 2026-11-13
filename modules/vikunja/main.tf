resource "azurecaf_name" "random_name_vikunja" {
  name          = "vikunja"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}

resource "docker_image" "vikunja" {
  name         = "vikunja/vikunja:latest"
  keep_locally = true
}

resource "docker_volume" "vikunja_db" {
  name = "vikunja_db"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_volume" "vikunja_files" {
  name = "vikunja_files"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_container" "vikunja" {
  name  = azurecaf_name.random_name_vikunja.result
  image = docker_image.vikunja.image_id

  ports {
    internal = 3456
    external = 3456
  }
  networks_advanced {
    name    = var.network_container
    aliases = ["vikunja"]
  }

  env = [
    "VIKUNJA_SERVICE_PUBLICURL=${var.vikunja_service_publicurl}"
  ]

  volumes {
    volume_name    = docker_volume.vikunja_db.name
    container_path = "/db"
  }

  volumes {
    volume_name    = docker_volume.vikunja_files.name
    container_path = "/app/vikunja/files"
  }
  restart = "always"
}
