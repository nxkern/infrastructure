output "ip_address" {
  value = docker_container.caddy.network_data[0].ip_address
}

