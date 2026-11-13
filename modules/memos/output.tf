output "ip_address" {
  value = docker_container.memos.network_data[0].ip_address
}
