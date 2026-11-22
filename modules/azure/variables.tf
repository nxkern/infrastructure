variable "url_image" {
  description = "url image docker"
  type        = string
}

variable "nuxt_api_key_worker" {
  description = "api key worker cf"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type = string

}
