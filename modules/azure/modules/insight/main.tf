resource "azurecaf_name" "random_name" {
  name          = "appinsights"
  resource_type = "azurerm_application_insights"
  prefixes      = ["appinsights"]
  suffixes      = ["prod"]
  random_length = 4
}

resource "azurerm_application_insights" "app_insights" {
  name                = azurecaf_name.random_name.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.workspace_id
}


