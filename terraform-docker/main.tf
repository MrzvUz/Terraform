terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "null_resource" "docker_vol" {
  provisioner "local-exec" {
    command = "mkdir nodered_vol/ || true && sudo chown -R 1000:1000 nodered_vol/"
  }
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

# This resources creates random strings which addes to suffix of our name using python join function.
resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nodered_container" {
  # Join functions is taking random variable from random resource and joins them adds random 4 suffixes to container name.
  count = local.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/nodered_vol"
  }
}