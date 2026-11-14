output "ip_address" {
  value = docker_container.yourspotify_server.network_data[0].ip_address
}
