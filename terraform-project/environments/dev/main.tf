provider "aws" {
  region = var.region
}

module "vpc" {
    source              = "../../modules/vpc"
    cidr_block          = var.cidr_block
    region              = var.region
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs= var.private_subnet_cidrs
    azs                 = var.azs
    env                 = var.env
    tags                = var.tags
}

module "alb" {
  source              = "../../modules/alb"
  security_groups     = var.security_groups
  alb_name                = var.alb_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  internal            = var.internal
  tags                = var.tags
<<<<<<< HEAD
  env                 = var.env
}

module "rds" {
  source              = "../../modules/rds"
  rds_name                = var.rds_name
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  env                 = var.env
  tags                = var.tags
  rds_port            = var.rds_port
  rds_password = var.rds_password
  rds_username = var.rds_username
  max_allocated_storage = var.max_allocated_storage
  allocated_storage = var.allocated_storage
  instance_class = var.instance_class
  engine = var.engine
  engine_version = var.engine_version
}
=======
}
>>>>>>> 897202a (resolving conflict)
