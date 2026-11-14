output "ip_address" {
  value = docker_container.kopia.network_data[0].ip_address
}
