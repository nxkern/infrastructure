resource "azurecaf_name" "random_name_adguardhome" {
  name          = "adguardhome"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}

resource "docker_image" "adguardhome" {
  name         = "adguard/adguardhome:latest"
  keep_locally = false
}

resource "docker_volume" "adguardhome_work" {
  name = "adguardhome_work"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_volume" "adguardhome_conf" {
  name = "adguardhome_conf"
  lifecycle {
    prevent_destroy = true
  }

}

resource "docker_container" "adguardhome" {
  name  = azurecaf_name.random_name_adguardhome.result
  image = docker_image.adguardhome.image_id

  ports {
    ip       = "192.168.0.106"
    internal = 53
    external = 53
    protocol = "tcp"
  }
  ports {
    ip       = "192.168.0.106"
    internal = 53
    external = 53
    protocol = "udp"
  }
  ports {
    ip       = "192.168.0.106"
    internal = 3000
    external = 3000
    protocol = "tcp"
  }
  ports {
    ip       = "192.168.0.106"
    internal = 80
    external = 8080
    protocol = "tcp"
  }

  networks_advanced {
    name    = var.network_container
    aliases = ["adguardhome"]
  }

  volumes {
    volume_name    = docker_volume.adguardhome_work.name
    container_path = "/opt/adguardhome/work"
  }
  volumes {
    volume_name    = docker_volume.adguardhome_conf.name
    container_path = "/opt/adguardhome/conf"
  }
  restart = "always"
}
