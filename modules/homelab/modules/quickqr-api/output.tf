output "ip_address" {
  value = docker_container.quickqr-api.network_data[0].ip_address
}

