provider "aws" {
  region = var.region
}

module "vpc" {
    source              = "../modules/vpc"
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
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  internal            = var.internal
  tags                = var.tags
}