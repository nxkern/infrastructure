
resource "docker_image" "website" {
  name = data.docker_registry_image.website.name 
  pull_triggers = [data.docker_registry_image.website.sha256_digest]
}


resource "azurecaf_name" "random_name_website" {
  name = "website"
  resource_type = "azurerm_resource_group"
  prefixes = ["prod"]
  suffixes  = ["001"]
  random_length = 4
  clean_input = true
}

resource "docker_container" "website" {
  name = azurecaf_name.random_name_website.result
  image = docker_image.website.image_id

  ports {
    internal = 3000
    external = 3010
  }
  networks_advanced {
    name = "homelab_net"
  }
  env = [
    "NUXT_API_KEY_WORKER=${var.nuxt_api_key_worker}"
  ]
  restart = "always"
}

resource "azurecaf_name" "random_name_homepage" {
  name = "homepage"
  resource_type = "azurerm_resource_group"
  prefixes = ["prod"]
  suffixes = ["001"]
  random_length = 4
  clean_input = true
}

resource "docker_image" "homepage" {
  name = "ghcr.io/gethomepage/homepage:latest"
}

resource "docker_container" "homepage" {
  name = azurecaf_name.random_name_homepage.result
  image = docker_image.homepage.image_id

  ports {
    internal = 3000
    external = 3005
  }
  networks_advanced {
    name = "homelab_net"
  }

  env = [
    "HOMEPAGE_ALLOWED_HOSTS=${var.homepage_allowed_host}"
  ]

  volumes {
    host_path = "/run/podman/podman.sock"
    container_path  = "/var/run/docker.sock"
    read_only = true
  }
  upload {
    file = "/app/config/services.yaml"
    content = file("${path.module}/config/homepage_config/services.yaml")
  }
  upload {
    file = "/app/config/bookmarks.yaml"
    content = file("${path.module}/config/homepage_config/bookmarks.yaml")
  }

  upload {
    file = "/app/config/widgets.yaml"
    content = file("${path.module}/config/homepage_config/widgets.yaml")
  }
  restart = "always"
}

resource "azurecaf_name" "random_name_vikunja" {
  name = "vikunja"
  resource_type = "azurerm_resource_group"
  prefixes = ["prod"]
  suffixes = ["001"]
  random_length = 4
  clean_input = true
}

resource "docker_image" "vikunja" {
  name = "vikunja/vikunja:latest"
}

resource "docker_volume" "vikunja_db" {
  name = "vikunja_db"
}

resource "docker_volume" "vikunja_files" {
  name = "vikunja_files"
}

resource "docker_container" "vikunja" {
  name = azurecaf_name.random_name_vikunja.result
  image = docker_image.vikunja.image_id

  ports {
    internal = 3456
    external = 3456
  }
  networks_advanced {
    name = "homelab_net"
  }

  env = [
    "VIKUNJA_SERVICE_PUBLICURL=${var.vikunja_service_publicurl}"
  ]

  volumes {
    volume_name = docker_volume.vikunja_db.name
    container_path = "/db"
  }

  volumes {
    volume_name = docker_volume.vikunja_files.name
    container_path = "/app/vikunja/files"
  }
  restart = "always"
}

resource "azurecaf_name" "random_name_memos" {
  name = "memos"
  resource_type = "azurerm_resource_group"
  prefixes = ["prod"]
  suffixes = ["001"]
  random_length = 4
  clean_input = true
}

resource "docker_image" "memos" {
  name = "neosmemo/memos:stable"
}

resource "docker_volume" "memos_data" {
  name = "memos_data"
}

resource "docker_container" "memos" {
  name = azurecaf_name.random_name_memos.result
  image = docker_image.memos.image_id

  ports {
    internal = 5230
    external = 5230
  }
  networks_advanced {
    name = "homelab_net"
  }
  volumes {
    volume_name = docker_volume.memos_data.name
    container_path = "/var/opt/memos"
  }
  restart = "always"
}

resource "azurecaf_name" "random_name_adguardhome" {
  name = "adguardhome"
  resource_type = "azurerm_resource_group"
  prefixes = ["prod"]
  suffixes = ["001"]
  random_length = 4
  clean_input = true
}

resource "docker_image" "adguardhome" {
  name = "adguard/adguardhome:latest"
}

resource "docker_volume" "adguardhome_work" {
  name = "adguardhome_work"
}

resource "docker_volume" "adguardhome_conf" {
  name = "adguardhome_conf"
}

resource "docker_container" "adguardhome" {
  name = azurecaf_name.random_name_adguardhome.result
  image = docker_image.adguardhome.image_id

  ports {
    internal = 53
    external = 53
    protocol = "tcp"
  }
  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }
  ports {
    internal = 3000
    external = 3000
    protocol = "tcp"
  }
  ports {
    internal = 80
    external = 8080
    protocol = "tcp"
  }

  networks_advanced {
    name = "homelab_net"
    aliases = ["adguardhome"]
  }

  volumes {
    volume_name = docker_volume.adguardhome_work.name
    container_path = "/opt/adguardhome/work"
  }
  volumes {
    volume_name = docker_volume.adguardhome_conf.name
    container_path = "/opt/adguardhome/conf"
  }
  restart = "always"
}

