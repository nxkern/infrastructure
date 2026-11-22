output "ip_address" {
  value = docker_container.vikunja.network_data[0].ip_address
}
