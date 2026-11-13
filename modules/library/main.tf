resource "azurecaf_name" "random_name_library" {
  name          = "library"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}

resource "docker_image" "library" {
  name         = "lscr.io/linuxserver/calibre-web:latest"
  keep_locally = true
}

resource "docker_volume" "calibre-config" {
  name = "calibre"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_volume" "calibre-book" {
  name = "calibre-book"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_container" "library" {
  name  = azurecaf_name.random_name_library.result
  image = docker_image.library.image_id

  ports {
    internal = 8083
    external = 8083
  }
  networks_advanced {
    name    = var.network_container
    aliases = ["library"]
  }


  volumes {
    volume_name    = docker_volume.calibre-book.name
    container_path = "/books"
  }
  volumes {
    volume_name    = docker_volume.calibre-config.name
    container_path = "/config"
  }

  env = [
    "PUID=${var.puid_library}",
    "PGID=${var.pgid_library}",
    "TZ=${var.tz_library}",
    "DOCKER_MODS=${var.docker_mods_library}",
    "OAUTHLIB_RELAX_TOKEN_SCOPE=${var.oauthlib_relax_token_scope}"
  ]
  restart = "unless-stopped"
}

