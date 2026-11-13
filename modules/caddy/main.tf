resource "docker_image" "caddy" {
  name         = "serfriz/caddy-duckdns:latest"
  keep_locally = true
}

resource "azurecaf_name" "random_name_caddy" {
  name          = "caddy"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}

resource "docker_volume" "caddy_data" {
  name = "caddy_data"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_volume" "caddy_config" {
  name = "caddy_config"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_container" "caddy" {
  name  = azurecaf_name.random_name_caddy.result
  image = docker_image.caddy.image_id

  capabilities {
    add = ["NET_ADMIN"]
  }

  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 443
  }

  ports {
    internal = 443
    external = 443
    protocol = "udp"
  }
  host {
    host = "website"
    ip   = var.website_ip
  }
  host {
    host = "homepage"
    ip   = var.homepage_ip
  }
  host {
    host = "adguardhome"
    ip   = var.adguardhome_ip
  }
  host {
    host = "library"
    ip   = var.library_ip
  }
  host {
    host = "memos"
    ip   = var.memos_ip
  }
  host {
    host = "vikunja"
    ip   = var.vikunja_ip
  }

  networks_advanced {
    name    = var.network_container
    aliases = ["caddy"]
  }

  volumes {
    volume_name    = docker_volume.caddy_data.name
    container_path = "/data"
  }
  volumes {
    volume_name    = docker_volume.caddy_config.name
    container_path = "/config"
  }

  upload {
    file    = "/etc/caddy/Caddyfile"
    content = file("${path.module}/config/Caddyfile")
  }
}


