variable "region" {
    type = string
    default = "us-east-1"
}

variable "cidr_block" {
    description = "VPC CIDR block"
    type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags for all resources fixed"
  type = map(string)
}

#for ALB

variable "security_groups" {
  type = list(string)
}

variable "internal" {
  type = bool
}

variable "name" {
  type = string
}