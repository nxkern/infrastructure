output "id" {
  value = docker_container.mongo_yourspotify.id
}

output "ip_address" {
  value = docker_container.mongo_yourspotify.network_data[0].ip_address
}

