output "ip_address" {
  value = docker_container.adguardhome.network_data[0].ip_address
}
