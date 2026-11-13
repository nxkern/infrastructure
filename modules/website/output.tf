output "ip_address" {
  value = docker_container.website.network_data[0].ip_address
}
