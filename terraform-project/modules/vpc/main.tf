resource "aws_vpc" "main" {
    cidr_block           = var.cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags                 = merge(var.tags, { Name = "${var.env}-vpc" })
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags   = merge(var.tags, { Name = "${var.env}-igw" })
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block        = var.public_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index % length(var.azs)]
    map_public_ip_on_launch = true
    tags              = merge(var.tags, { Name = "${var.env}-public-${count.index}" })
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block        = var.private_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index % length(var.azs)]
    map_public_ip_on_launch = true
    tags              = merge(var.tags, { Name = "${var.env}-private-${count.index}" })
}

resource "aws_eip" "nat" {
    count = length(var.public_subnet_cidrs)
    domain                    = "vpc"
    tags = merge(var.tags, {Name = "${var.env}-nat-eip-${count.index}"})
}

resource "aws_security_group" "nat_instance_sg" {
  name        = "nat-instance-sg"
  description = "Allow HTTP/HTTPS and SSH for NAT instance"
  vpc_id      = aws_vpc.main.id

	ingress {
		from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {Name = "${var.env}-nat-instance-sg"})
}


resource "aws_instance" "nat" {
  ami                         = "ami-0c02fb55956c7d316" #
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id # Launching in the first public subnet
  associate_public_ip_address = true
  source_dest_check           = false                   # Allows instance to forward traffic (NAT behavior)

  vpc_security_group_ids = [aws_security_group.nat_instance_sg.id]

  tags = merge(var.tags, {Name = "${var.env}-nat-instance"})

  user_data = <<-EOF
              #!/bin/bash
              # Enable IP forwarding by adding 1 to the ip forward file
              echo 1 > /proc/sys/net/ipv4/ip_forward
              
              # Configure NAT with iptables: masquerade outbound traffic through eth0
              iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              EOF
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.env}-public-rt" })
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.env}-private-rt" })
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "private_nat_access" {
  count                   = length(var.private_subnet_cidrs)
  route_table_id          = aws_route_table.private.id
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_instance.nat.id 
}
