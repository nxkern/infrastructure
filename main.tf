resource "docker_network" "homelab_net" {
  name   = "homelab_net"
  driver = "bridge"
  lifecycle {
    ignore_changes = [options, ipam_options, ipam_config]
  }
}

module "website" {
  source              = "./modules/website"
  nuxt_api_key_worker = var.nuxt_api_key_worker
  network_container   = docker_network.homelab_net.name
  url_image           = var.url_image
  worker_host         = var.worker_api
  ip_worker           = var.worker_api_ip
}

module "homepage" {
  source                       = "./modules/homepage"
  network_container            = docker_network.homelab_net.name
  homepage_allowed_host        = var.homepage_allowed_host
  homepage_var_yourspotify_key = var.homepage_api_yourspotify
  homepage_var_vikunja_key     = var.homepage_api_vikunja
  depends_on = [
    module.vikunja,
    module.memos,
    module.adguardhome,
    module.library,
    module.kopia,
  ]

}

module "vikunja" {
  source                    = "./modules/vikunja"
  network_container         = docker_network.homelab_net.name
  vikunja_service_publicurl = var.vikunja_service_publicurl
}

module "memos" {
  source            = "./modules/memos"
  network_container = docker_network.homelab_net.name
}

module "adguardhome" {
  source            = "./modules/adguardhome"
  network_container = docker_network.homelab_net.name
}

module "library" {
  source                     = "./modules/library"
  network_container          = docker_network.homelab_net.name
  puid_library               = var.puid_library
  pgid_library               = var.pgid_library
  tz_library                 = var.tz_library
  docker_mods_library        = var.docker_mods_library
  oauthlib_relax_token_scope = var.oauthlib_relax_token_scope
}

module "caddy" {
  source             = "./modules/caddy"
  network_container  = docker_network.homelab_net.name
  domain_quickqr_api = var.domain_quickqr_api
  depends_on = [
    module.website,
    module.adguardhome,
    module.homepage,
    module.kopia,
    module.library,
    module.memos,
    module.quickqr-api,
    module.vikunja
  ]
}

module "cloudflared" {
  source            = "./modules/cloudflared"
  token_cloudflared = var.token_cloudflared
  depends_on = [
    module.caddy
  ]
}

# module "yourspotify" {
#   source            = "./modules/yourspotify"
#   network_container = docker_network.homelab_net.name
#   api_endpoint      = var.api_endpoint_yourspotify
#   client_endpoint   = var.client_endpoint_yourspotify
#   spotify_public    = var.spotify_public
#   spotify_secret    = var.spotify_secret
#   host_homelab      = var.ip_host
#   path_home         = var.path_home
# }

module "kopia" {
  source            = "./modules/kopia"
  network_container = docker_network.homelab_net.name
  path_home         = var.path_home_backups_kopia
  password          = var.password_respository_kopia
  user              = var.user_repository_kopia
  rclone_token      = var.kopia_rclone_token
}

module "quickqr-api" {
  source            = "./modules/quickqr-api"
  network_container = docker_network.homelab_net.name
  url_image         = var.url_image_quickqr_api

}
