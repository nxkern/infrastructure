
variable "connection_string" {
  description = "The connection string for the OpenTelemetry Collector to send data to the backend."
  type        = string
  sensitive   = true
}

variable "network_container" {
  description = "The name of the Docker network container to connect the OpenTelemetry Collector to."
  type        = string
}
