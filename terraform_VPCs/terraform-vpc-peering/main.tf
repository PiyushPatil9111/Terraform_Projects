module "main_vpc" {
	source = "../terraform-vpc-project"
}

#Creating a shared VPC that will be peered with the main vpc
resource "aws_vpc" "shared_vpc" {
  cidr_block = var.shared_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "shared-services-vpc"
  }
}

# Create public subnets in shared VPC
resource "aws_subnet" "shared_public_subnets" {
  count                   = length(var.shared_public_subnet_cidrs)
  vpc_id                  = aws_vpc.shared_vpc.id
  cidr_block              = var.shared_public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]
  tags = {
    Name = "shared-public-subnet-${count.index + 1}"
	}
}

# Create private subnets in shared VPC
resource "aws_subnet" "shared_private_subnets" {
  count             = length(var.shared_private_subnet_cidrs)
  vpc_id            = aws_vpc.shared_vpc.id
  cidr_block        = var.shared_private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "shared-private-subnet-${count.index + 1}"
	}
}

# Data source for AZs (for subnet placement)
data "aws_availability_zones" "available" {}

#Creating VPC peering request from main VPC to shared VPC
resource "aws_vpc_peering_connection" "vpc_peering" {
	vpc_id = module.main_vpc.requester_vpc_id
	peer_vpc_id = aws_vpc.shared_vpc.id
	auto_accept = true
	
	accepter {
    	allow_remote_vpc_dns_resolution = true
  	}

  	requester {
    	allow_remote_vpc_dns_resolution = true
  	}

  tags = {
    Name = "main-to-shared-peering"
  }
}

#Creating a route table for main vpc to send traffic to shared vpc
resource "aws_route" "main_vpc_route_to_shared"{
	route_table_id = module.main_vpc.main_private_route_table
	destination_cidr_block = var.shared_vpc_cidr
	vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

#Creating the ROute table for the shared VPC and route for main vpc to peering connection for Nat instance access
resource "aws_route_table" "shared_private_route_table"{
	vpc_id = aws_vpc.shared_vpc.id
	route {
   		cidr_block = module.main_vpc.requester_vpc_cidr
    		vpc_peering_connection_id  = aws_vpc_peering_connection.vpc_peering.id
  }
	tags = {
    		Name = "shared_private_route_table"
  	}
}

# Associate private subnets with route table
resource "aws_route_table_association" "shared_private_associations" {
  count          = length(aws_subnet.shared_private_subnets)
  subnet_id      = aws_subnet.shared_private_subnets[count.index].id
  route_table_id = aws_route_table.shared_private_route_table.id
}

resource "aws_vpc_endpoint" "main_s3_endpoint" {
  vpc_id            = module.main_vpc.requester_vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.main_vpc.main_private_route_table]

  tags = {
    Name = "main-vpc-s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "shared_s3_endpoint" {
  vpc_id            = aws_vpc.shared_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.shared_private_route_table.id]  # Should be created in shared VPC module

  tags = {
    Name = "shared-vpc-s3-endpoint"
  }
}
