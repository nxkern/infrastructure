module "yourspotify_client" {
  source            = "./modules/client"
  api_endpoint      = var.api_endpoint
  network_container = var.network_container
}

module "mongo_yourspotify" {
  source            = "./modules/db"
  network_container = var.network_container
}


module "yourspotify_server" {
  source            = "./modules/server"
  network_container = var.network_container
  api_endpoint      = var.api_endpoint
  client_endpoint   = var.client_endpoint
  spotify_public    = var.spotify_public
  spotify_secret    = var.spotify_secret
  mongo_module      = module.mongo_yourspotify.id
  mongo_ip          = module.mongo_yourspotify.ip_address
}



