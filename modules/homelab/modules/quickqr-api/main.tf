resource "docker_image" "quickqr-api" {
  name          = "${data.docker_registry_image.quickqr-api.name}@${data.docker_registry_image.quickqr-api.sha256_digest}"
  pull_triggers = [data.docker_registry_image.quickqr-api.sha256_digest]
  keep_locally  = false
}

resource "azurecaf_name" "random_name_quickqr-api" {
  name          = "quickqr-api"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod", "quick"]
  suffixes      = ["001", "qr", "api"]
  random_length = 4
  clean_input   = true
}

resource "docker_container" "quickqr-api" {
  name  = azurecaf_name.random_name_quickqr-api.result
  image = docker_image.quickqr-api.image_id


  ports {
    internal = 8080
    external = 8090
  }
  networks_advanced {
    name    = var.network_container
    aliases = ["quickqr_api"]
  }
  env = [
    "OTEL_EXPORTER_OTLP_ENDPOINT=${var.otlp_endpoint}",
    "OTEL_SERVICE_NAME=${var.otel_service_name}",
  ]
  restart = "unless-stopped"
}
