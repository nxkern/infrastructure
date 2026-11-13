output "ip_address" {
  value = docker_container.library.network_data[0].ip_address
}
