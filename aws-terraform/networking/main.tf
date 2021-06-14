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

  # Assign tag which is referencing from random_integer on top which assign random number at the end of my_vpc.
  tags = {
    Name = "my_vpc - ${random_integer.random.id}"
  }
  # Lifecycle policy creates new vpc before destroying it so IGW can reassociate to new VPC.
  lifecycle {
    create_before_destroy = true
  }
}

# 3. Randomly shuffles AZs and randomly assignes AZ to a subnet so we don't have to hard code. It also eliminates max count error of AZs.
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

# 05. Create subnet resource in a vpc.
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

# 06. Create IGW and associate route tables with IGW.
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

# 07. Create route table and associate with IGW.
resource "aws_route_table" "my_public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_public_rt"
  }
}

# Create RT association to connect to the each public subnets.
resource "aws_route_table_association" "my_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.my_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.my_public_route_table.id
}

# 08. Create default route table.
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

# 09. Create default private route table and associate it with default_route so if no RT specified by default RT will assign to Private RT for security.
resource "aws_default_route_table" "my_private_route_table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  tags = {
    Name = "my_private_rt"
  }
}

# Create Security Groups.
resource "aws_security_group" "my_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.my_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create RDS subnet.
resource "aws_db_subnet_group" "my_rds_subnetgroup" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "my_rds_subnetgroup"
  subnet_ids = aws_subnet.my_private_subnet.*.id
  tags = {
    Name = "my_rds_sng"
  }
}
