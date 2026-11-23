output "ip_address" {
  value = docker_container.collector.network_data[0].ip_address
}
