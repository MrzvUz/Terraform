module "image" {
  source   = "./image"
  image_in = var.image[terraform.workspace]
}

# This resources creates random strings which addes to suffix of our name using python join function.
resource "random_string" "random" {
  # count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

module "container" {
  source = "./container"
  # Join functions is taking random variable from random resource and joins them adds random 4 suffixes to container name.
  # count             = local.container_count
  name_in           = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image_in          = module.image.image_out
  int_port_in       = var.int_port
  ext_port_in       = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
  host_path_in      = "${path.cwd}/nodered_vol"
}