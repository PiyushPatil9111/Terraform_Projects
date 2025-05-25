resource "aws_route_table" "private_route_table" {
	vpc_id = aws_vpc.main_vpc.id

	tags = {
		Name = "private-rt"
	}
}

data "aws_network_interface" "nat_eni" {
  filter {
    name   = "attachment.instance-id"
    values = [aws_instance.nat.id]
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = data.aws_network_interface.nat_eni.id
}
