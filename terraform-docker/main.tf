resource "null_resource" "docker_vol" {
  provisioner "local-exec" {
    command = "mkdir nodered_vol/ || true && sudo chown -R 1000:1000 nodered_vol/"
  }
}

module "image" {
  source   = "./image"
  image_in = var.image[terraform.workspace]
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
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = module.image.image_out
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/nodered_vol"
  }
}