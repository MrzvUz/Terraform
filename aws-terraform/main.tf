# --- root/main.tf ---

module "networking" {                # referencing to ./networking/main.tf
  source           = "./networking"  # pulling the info source from module file in ./terworking/main.tf
  vpc_cidr         = "10.123.0.0/16" # cidr_block is referencing to module file in ./terworking/main.tf my_vpc resource
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet("10.123.0.0/16", 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet("10.123.0.0/16", 8, i)]
}

