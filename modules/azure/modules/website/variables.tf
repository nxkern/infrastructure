variable "nuxt_api_key_worker" {
  description = "api key worker cf"
  type        = string
  sensitive   = true
}

variable "url_image" {
  description = "url image docker"
  type        = string
}

variable "container_app_environment_id" {
  description = "id container app"
  type        = string
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
}
