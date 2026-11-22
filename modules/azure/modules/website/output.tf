output "ip_public" {
  value = "https://${azurerm_container_app.website.ingress[0].fqdn}"
}

output "container_app_id" {
  value = azurerm_container_app.website.id
}

output "fqdn" {
  value = azurerm_container_app.website.ingress[0].fqdn
}

output "verification_id" {
  value = azurerm_container_app.website.custom_domain_verification_id
}
