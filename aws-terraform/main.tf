# --- root/main.tf ---


module "networking" {        # referencing to ./networking/main.tf
  source   = "./networking"  # pulling the info source from module file in ./terworking/main.tf
  vpc_cidr = "10.123.0.0/16" # cidr_block is referencing to module file in ./terworking/main.tf my_vpc resource
}

