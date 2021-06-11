locals {
  container_count = length(var.ext_port[terraform.workspace])
}
