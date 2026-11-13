variable "network_container" {
  description = "network container"
  type        = string
}

variable "puid_library" {
  description = "puid library web"
  type        = number
}


variable "pgid_library" {
  description = "pgid library web"
  type        = number
}


variable "tz_library" {
  description = "time zone"
  type        = string
}


variable "docker_mods_library" {
  description = "mods library"
  type        = string
}

variable "oauthlib_relax_token_scope" {
  description = "oauth library"
  type        = number
}
