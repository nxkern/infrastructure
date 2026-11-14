resource "azurecaf_name" "random_name_kopia" {
  name          = "kopia"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod", "ko"]
  suffixes      = ["001", "pia"]
  random_length = 3
  clean_input   = true
}

resource "docker_image" "kopia" {
  name         = "kopia/kopia:latest"
  keep_locally = true
}

resource "docker_volume" "kopia_config" {
  name = "kopia_config"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "kopia_cache" {
  name = "kopia_cache"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "kopia_logs" {
  name = "kopia_logs"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_container" "kopia" {
  name  = azurecaf_name.random_name_kopia.result
  image = docker_image.kopia.image_id
  dns   = ["1.1.1.1", "8.8.8.8"]

  ports {
    internal = 51515
    external = 51515
  }

  networks_advanced {
    name    = var.network_container
    aliases = ["kopia"]
  }

  command = [
    "server",
    "start",
    "--disable-csrf-token-checks",
    "--insecure",
    "--address=0.0.0.0:51515",
    "--server-username=${var.user}",
    "--server-password=${var.password}",
  ]

  env = [
    "KOPIA_PASSWORD=${var.password}",
    "USER=${var.user}",
  ]

  volumes {
    host_path      = var.path_home
    container_path = "/data"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.kopia_config.name
    container_path = "/app/config"
  }

  volumes {
    volume_name    = docker_volume.kopia_logs.name
    container_path = "/app/logs"
  }

  volumes {
    volume_name    = docker_volume.kopia_cache.name
    container_path = "/app/cache"
  }

  upload {
    file    = "/app/rclone/rclone.conf"
    content = <<-EOT
      [gdrive]
      type = drive
      scope = drive
      token = ${trimspace(var.rclone_token)}
    EOT
  }
  restart = "unless-stopped"

}
