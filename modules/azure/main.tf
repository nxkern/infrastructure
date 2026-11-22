resource "azurerm_resource_group" "rg_web" {
  location = "brazilsouth"
  name     = "rg_web"
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "law-env-apps"
  location            = azurerm_resource_group.rg_web.location
  resource_group_name = azurerm_resource_group.rg_web.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                       = "env-apps-wd"
  location                   = azurerm_resource_group.rg_web.location
  resource_group_name        = azurerm_resource_group.rg_web.name
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
  lifecycle {
    ignore_changes = [workload_profile]
  }
}

module "website" {
  source                       = "./modules/website"
  resource_group_name          = azurerm_resource_group.rg_web.name
  url_image                    = var.url_image
  nuxt_api_key_worker          = var.nuxt_api_key_worker
  container_app_environment_id = azurerm_container_app_environment.env.id
}


resource "cloudflare_dns_record" "website_cname" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  content = module.website.fqdn
  type    = "CNAME"
  ttl     = 1
  proxied = true

  lifecycle {
    ignore_changes = [proxied]
  }

}
