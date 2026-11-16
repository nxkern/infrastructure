resource "docker_image" "mongo_yourspotify" {
  name         = "mongo:4.4"
  keep_locally = true
}

resource "docker_volume" "mongo_db" {
  name = "mongo_db"
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurecaf_name" "random_name_mongo" {
  name          = "mongo_yourspotify"
  resource_type = "azurerm_resource_group"
  prefixes      = ["prod", "your"]
  suffixes      = ["001", "spotify"]
  random_length = 4
  clean_input   = true
}

resource "docker_container" "mongo_yourspotify" {
  name  = azurecaf_name.random_name_mongo.result
  image = docker_image.mongo_yourspotify.image_id

  networks_advanced {
    name    = var.network_container
    aliases = ["mongo"]
  }

  volumes {
    volume_name    = docker_volume.mongo_db.name
    container_path = "/data/db"
  }
  restart = "always"
}

resource "null_resource" "deploy_mongo_backup_script" {
  triggers = {
    container_name = docker_container.mongo_yourspotify.name
    path_home      = var.path_home
    shebang        = "sh"
    cron_schedule  = "30 7,19 * * *"
  }
  connection {
    type  = "ssh"
    host  = var.host_homelab
    user  = "nxus"
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.path_home}/scripts ${var.path_home}/backups/mongo"
    ]
  }

  provisioner "file" {
    destination = "${var.path_home}/scripts/backups_mongo.sh"
    content     = <<-EOF
      #!/bin/sh
      set -e
      podman exec "${docker_container.mongo_yourspotify.name}" mongodump --archive=/tmp/mongo.archive --gzip
      podman cp "${docker_container.mongo_yourspotify.name}":/tmp/mongo.archive ${var.path_home}/backups/mongo/mongo.archive.tmp
      podman exec "${docker_container.mongo_yourspotify.name}" rm -f /tmp/mongo.archive
      mv -f ${var.path_home}/backups/mongo/mongo.archive.tmp ${var.path_home}/backups/mongo/mongo.archive
    EOF
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${var.path_home}/scripts/backups_mongo.sh",
      "(crontab -l 2>/dev/null | grep -v '${var.path_home}/scripts/backups_mongo.sh'; echo '${self.triggers.cron_schedule} ${var.path_home}/scripts/backups_mongo.sh') | crontab -"
    ]
  }
}
