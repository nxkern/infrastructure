resource "azurecaf_name" "random_name_homepage" {
  name          = "homepage"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}

resource "docker_image" "homepage" {
  name         = "ghcr.io/gethomepage/homepage:latest"
  keep_locally = true
}

resource "docker_container" "homepage" {
  name  = azurecaf_name.random_name_homepage.result
  image = docker_image.homepage.image_id
  dns   = ["1.1.1.1", "8.8.8.8"]


  ports {
    internal = 3000
    external = 3005
  }
  networks_advanced {
    name    = var.network_container
    aliases = ["homepage"]
  }

  env = [
    "HOMEPAGE_ALLOWED_HOSTS=${var.homepage_allowed_host}",
    "HOMEPAGE_VAR_YOURSPOTIFY_KEY=${var.homepage_var_yourspotify_key}",
    "HOMEPAGE_VAR_VIKUNJA_KEY=${var.homepage_var_vikunja_key}",
  ]

  volumes {
    host_path      = "/run/podman/podman.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }
  upload {
    file    = "/app/config/services.yaml"
    content = file("${path.module}/config//services.yaml")
  }
  upload {
    file    = "/app/config/bookmarks.yaml"
    content = file("${path.module}/config//bookmarks.yaml")
  }

  upload {
    file    = "/app/config/widgets.yaml"
    content = file("${path.module}/config//widgets.yaml")
  }
  restart = "always"
}

