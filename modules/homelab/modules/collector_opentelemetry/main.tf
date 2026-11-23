resource "azurecaf_name" "random_name_collector" {
  name          = "collector"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}


resource "docker_image" "collector" {
  name         = "otel/opentelemetry-collector-contrib:latest"
  keep_locally = false
}

resource "docker_container" "collector" {
  name  = azurecaf_name.random_name_collector.result
  image = docker_image.collector.image_id

  networks_advanced {
    name    = var.network_container
    aliases = ["collector"]
  }

  upload {
    file    = "/etc/otelcol-contrib/config.yaml"
    content = file("${path.module}/config/config.yaml")
  }
  ports {
    internal = 4317
    external = 4317
  }
  ports {
    internal = 13133
    external = 13133
  }
  env = [
    "CONNECTION_STRING=${var.connection_string}",
  ]
}
