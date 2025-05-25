variable "shared_vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "region" {
	type = string
	default = "us-east-1"
}

variable "shared_public_subnet_cidrs" {
  type    = list(string)
  default = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "shared_private_subnet_cidrs" {
  type    = list(string)
  default = ["10.2.101.0/24", "10.2.102.0/24"]
}

variable "availability_zones" {
	type = list(string)
	default = ["us-east-1a", "us-east-1b"]
}
