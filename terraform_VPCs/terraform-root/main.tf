provider "aws" {
  region = var.region
}

module "main_vpc" {
  source = "../terraform-vpc-project"
  
  requester_vpc_id = aws_vpc.main_vpc.id
  main_public_subnet = aws_subnet.public_subnets.id
  main_private_subnet = aws_subnet.private_subnets.id
  main_private_route_table = aws_route_table.private_route_table.id
  main_public_route_table = aws_route_table.public_route_table.id
}

module "vpc_peering" {
  source = "../terraform-vpc-peering"

  region                  = var.region
  accepter_vpc_id         = aws_vpc.shared_vpc
  shared_vpc_cidr         = var.shared_vpc_cidr
  shared_public_subnet_cidrs  = var.shared_public_subnet_cidrs
  shared_private_subnet_cidrs = var.shared_private_subnet_cidrs

  # Pass route table ids if needed, e.g.
  main_vpc_route_table_ids = module.main_vpc.private_route_table_ids  # add this output in main_vpc module if needed
}
