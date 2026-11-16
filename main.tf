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
}

module "homepage" {
  source                       = "./modules/homepage"
  network_container            = docker_network.homelab_net.name
  homepage_allowed_host        = var.homepage_allowed_host
  homepage_var_yourspotify_key = var.homepage_api_yourspotify
  homepage_var_vikunja_key     = var.homepage_api_vikunja

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
  source                     = "./modules/caddy"
  network_container          = docker_network.homelab_net.name
  website_ip                 = module.website.ip_address
  homepage_ip                = module.homepage.ip_address
  adguardhome_ip             = module.adguardhome.ip_address
  library_ip                 = module.library.ip_address
  memos_ip                   = module.memos.ip_address
  vikunja_ip                 = module.vikunja.ip_address
  yourspotify_client_ip      = module.yourspotify.ip_address_client_yourspotify
  yourspotify_server_ip      = module.yourspotify.ip_address_server_yourspotify
  yourspotify_mongo_ip       = module.yourspotify.ip_address_mongo_yourspotify
  domain_backend_yourspotify = var.domain_backend_yourspotify
  kopia_ip                   = module.kopia.ip_address
}

module "cloudflared" {
  source            = "./modules/cloudflared"
  token_cloudflared = var.token_cloudflared
}

module "yourspotify" {
  source            = "./modules/yourspotify"
  network_container = docker_network.homelab_net.name
  api_endpoint      = var.api_endpoint_yourspotify
  client_endpoint   = var.client_endpoint_yourspotify
  spotify_public    = var.spotify_public
  spotify_secret    = var.spotify_secret
  host_homelab      = var.ip_host
  path_home         = var.path_home
}

module "kopia" {
  source            = "./modules/kopia"
  network_container = docker_network.homelab_net.name
  path_home         = var.path_home_backups_kopia
  password          = var.password_respository_kopia
  user              = var.user_repository_kopia
  rclone_token      = var.kopia_rclone_token
}
