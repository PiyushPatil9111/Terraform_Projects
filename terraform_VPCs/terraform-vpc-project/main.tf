resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc-${var.vpc_cidr}"
  }
}

#USE OF COUNT, for Eg. in the public subnet block below, we have created a variable in varible.tf file named as public_subnet_cidrs in which we have specified 2 values of cidr ranges as the default values. fo first we save the number of values in the count var in the resource block and then we use count.index as a simple for loop that runs for the default values in the variable. Here two subnets will be created with CIDR values as "10.0.1.0/24", "10.0.2.0/24", this way we skip writing the same block twice

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "main-public-subnet-${var.public_subnet_cidrs[count.index]}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "main-private-subnet-${var.private_subnet_cidrs[count.index]}"
  }
}
