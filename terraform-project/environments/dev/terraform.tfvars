cidr_block          = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs= ["10.0.101.0/24", "10.0.102.0/24"]
azs                 = ["us-east-1a", "us-east-1b"]
env                 = "dev"
tags = {
  Owner   = "piyush"
  Project = "terraform-portfolio"
}
#ALB
security_groups = ["dev-alb-SG"]
internal = false
alb_name = "dev-public-alb"

#RDS
rds_name = "dev-private-rds"
rds_port = "3306"
rds_username = "rds_user"
rds_password = "rds@12345"
max_allocated_storage = 35
allocated_storage = 20
instance_class = "db.t3.micro"
engine = "mysql"
engine_version = "8.0.36"