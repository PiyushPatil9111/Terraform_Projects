output "main_vpc_public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "main_vpc_private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output  "requester_vpc_id" {
	value = aws_vpc.main_vpc.id
}

output "requester_vpc_cidr" {
	value = var.vpc_cidr
}

output "main_private_route_table" {
	value = aws_route_table.private_route_table.id
}

output "main_public_route_table" {
	value = aws_route_table.public_route_table.id
}

output "main_vpc_region" {
	value = "us-east-1"
}
