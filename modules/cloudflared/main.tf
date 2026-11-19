resource "docker_image" "cloudflared" {
  name         = "docker.io/cloudflare/cloudflared:latest"
  keep_locally = false
}

resource "azurecaf_name" "random_name_cloudflared" {
  name          = "cloudflared"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod"]
  suffixes      = ["001"]
  random_length = 5
  clean_input   = true
}

resource "docker_container" "cloudflared" {
  name         = azurecaf_name.random_name_cloudflared.result
  image        = docker_image.cloudflared.image_id
  network_mode = "host"

  command = [
    "tunnel",
    "--no-autoupdate",
    "run",
    "--token",
    var.token_cloudflared
  ]

  restart = "always"
}
