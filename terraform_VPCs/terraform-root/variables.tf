variable "region" {
  default = "us-east-1"
}

variable "shared_vpc_cidr" {
  default = "10.2.0.0/16"
}

variable "shared_public_subnet_cidrs" {
  default = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "shared_private_subnet_cidrs" {
  default = ["10.2.101.0/24", "10.2.102.0/24"]
}

