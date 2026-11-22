variable "host_homelab" {
  description = "homelab host"
  type        = string
}

# variable "url_image" {
#   type = string
# }

# variable "nuxt_api_key_worker" {
#   type = string
# }

variable "homepage_allowed_host" {
  type = string
}

variable "vikunja_service_publicurl" {
  type = string
}

variable "puid_library" {
  type = number
}

variable "pgid_library" {
  type = number
}

variable "tz_library" {
  type = string
}

variable "docker_mods_library" {
  type = string
}

variable "oauthlib_relax_token_scope" {
  type = number
}

variable "account_id" {
  type    = string
  default = "<YOUR_ACCOUNT_ID>"
}

variable "token_cloudflared" {
  description = "token cloudflared"
  type        = string
  sensitive   = true
}

variable "api_endpoint_yourspotify" {
  type = string
}

variable "client_endpoint_yourspotify" {
  type = string
}

variable "spotify_public" {
  type      = string
  sensitive = true
}

variable "spotify_secret" {
  type      = string
  sensitive = true
}

variable "domain_backend_yourspotify" {
  type      = string
  sensitive = true
}

variable "homepage_api_yourspotify" {
  type      = string
  sensitive = true
}

variable "homepage_api_vikunja" {
  type      = string
  sensitive = true
}

variable "path_home_backups_kopia" {
  type = string
}

variable "password_respository_kopia" {
  type      = string
  sensitive = true
}

variable "user_repository_kopia" {
  type = string
}

variable "kopia_rclone_token" {
  type      = string
  sensitive = true
}

variable "ip_host" {
  type = string
}

variable "path_home" {
  type = string
}

variable "url_image_quickqr_api" {
  type = string
}
variable "domain_quickqr_api" {
  type = string
}

variable "worker_api" {
  type      = string
  sensitive = true
}

variable "worker_api_ip" {
  type      = string
  sensitive = true
}
