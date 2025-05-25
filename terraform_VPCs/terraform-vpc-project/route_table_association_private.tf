resource "aws_route_table_association" "private" {
	count = length(var.private_subnet_cidrs)
	subnet_id = aws_subnet.private_subnets[count.index].id
	route_table_id = aws_route_table.private_route_table.id
}
