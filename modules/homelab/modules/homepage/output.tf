output "ip_address" {
  value = docker_container.homepage.network_data[0].ip_address
}
