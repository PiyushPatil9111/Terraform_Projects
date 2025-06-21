resource "aws_db_subnet_group" "dev_rds_subnet_gp" {
  name       = "${var.rds_name}-subnet-group"
  subnet_ids = var.private_subnet_ids[0]

  tags = {
    Name = "${var.rds_name}-subnet-group"
  }
}

resource "aws_security_group" "dev_rds_sg" {
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

resource "aws_db_instance" "my_db" {
  identifier              = var.rds_name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  db_name                 = var.rds_name
  username                = var.rds_username
  password                = var.rds_password
  port                    = var.rds_port
  vpc_security_group_ids  = aws_security_group.dev_rds_sg.id
  db_subnet_group_name    = aws_db_subnet_group.dev_rds_subnet_gp.name
  skip_final_snapshot     = true
  publicly_accessible     = var.publicly_accessible
  multi_az                = var.multi_az

  tags = {
    Name = var.rds_name
  }
}
