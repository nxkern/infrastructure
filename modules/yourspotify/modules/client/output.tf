output "ip_address" {
  value = docker_container.yourspotify_client.network_data[0].ip_address
}

