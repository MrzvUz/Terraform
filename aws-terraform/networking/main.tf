# --- networking/main.tf ---

# 1. Assign random integer. Random integer allows to assign new random number to each resource.
resource "random_integer" "random" {
  min = 1
  max = 100
}

# 2. Create VPC resource. Creates VPC with my_vpc name. Cidr block is referencing from networking/variables.tf file.
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Allows to assign dns hostname.
  enable_dns_support   = true # Allows to enable dns support.

  # 3. Assign tag which is referencing from random_integer on top which assign random number at the end of my_vpc.
  tags = {
    Name = "my_vpc - ${random_integer.random.id}"
  }
}

# Randomly shuffles AZs and randomly assignes AZ to a subnet so we don't have to hard code. It also eliminates max count error of AZs.
resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

# 4. Auto collects the number of availability zones in a region.
data "aws_availability_zones" "available" {}

resource "aws_subnet" "my_public_subnet" {
  cidr_block              = var.public_cidrs[count.index]
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone       = random_shuffle.az_list.result[count.index] # resource from data source [count.index] auto-assigns to availability_zone.
  map_public_ip_on_launch = true

  tags = {
    Name = "my_public_subnet${count.index + 1}"
  }
}

resource "aws_subnet" "my_private_subnet" {
  cidr_block              = var.private_cidrs[count.index]
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone       = random_shuffle.az_list.result[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "my_private_subnet${count.index + 1}"
  }
}
