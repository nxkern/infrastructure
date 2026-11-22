module "homelab" {
  source                      = "./modules/homelab"
  ip_host                     = var.ip_host
  worker_api                  = var.worker_api
  url_image_quickqr_api       = var.url_image_quickqr_api
  host_homelab                = var.host_homelab
  password_respository_kopia  = var.password_respository_kopia
  spotify_secret              = var.spotify_secret
  spotify_public              = var.spotify_public
  docker_mods_library         = var.docker_mods_library
  vikunja_service_publicurl   = var.vikunja_service_publicurl
  tz_library                  = var.tz_library
  kopia_rclone_token          = var.kopia_rclone_token
  path_home                   = var.path_home
  homepage_allowed_host       = var.homepage_allowed_host
  homepage_api_yourspotify    = var.homepage_api_yourspotify
  client_endpoint_yourspotify = var.client_endpoint_yourspotify
  homepage_api_vikunja        = var.homepage_api_yourspotify
  domain_backend_yourspotify  = var.domain_backend_yourspotify
  domain_quickqr_api          = var.domain_quickqr_api
  oauthlib_relax_token_scope  = var.oauthlib_relax_token_scope
  user_repository_kopia       = var.user_repository_kopia
  path_home_backups_kopia     = var.path_home_backups_kopia
  puid_library                = var.puid_library
  pgid_library                = var.puid_library
  api_endpoint_yourspotify    = var.api_endpoint_yourspotify
  worker_api_ip               = var.worker_api
  token_cloudflared           = var.token_cloudflared
}

module "azure" {
  source              = "./modules/azure"
  url_image           = var.url_image
  nuxt_api_key_worker = var.nuxt_api_key_worker
  cloudflare_zone_id  = data.cloudflare_zone.nxbin.id
}


