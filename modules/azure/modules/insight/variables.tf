variable "location" {
  description = "Azure location for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "workspace_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
}
