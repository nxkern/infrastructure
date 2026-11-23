variable "network_container" {
  description = "net container"
  type        = string
}

variable "url_image" {
  description = "url image docker hub"
  type        = string
}

variable "otlp_endpoint" {
  description = "OTLP endpoint for OpenTelemetry"
  type        = string
}

variable "otel_service_name" {
  description = "Service name for OpenTelemetry"
  type        = string
}
