resource "azurecaf_name" "random_name_website" {
  name          = "website"
  resource_type = "azurerm_container_app"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 4
  clean_input   = true
}

resource "azurerm_container_app" "website" {
  name                         = azurecaf_name.random_name_website.result
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 3000
    transport        = "auto"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    min_replicas               = 0
    max_replicas               = 1
    cooldown_period_in_seconds = 60

    container {
      name   = azurecaf_name.random_name_website.result
      image  = var.url_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "nuxt_api_key_worker"
        value = var.nuxt_api_key_worker
      }
      env {
        name  = "NITRO_HOST"
        value = "0.0.0.0"
      }
      env {
        name  = "NITRO_PORT"
        value = "3000"
      }

    }

  }

}
