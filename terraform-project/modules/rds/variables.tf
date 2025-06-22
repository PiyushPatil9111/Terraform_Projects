variable "env" {
  type = string
}
variable "rds_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type = string
}
variable "allocated_storage" {
  type = number
}
variable "max_allocated_storage" {
  type        = number
}
variable "rds_username" {
  type        = string
}
variable "rds_password" {
  type        = string
  sensitive   = true
}
variable "rds_port" {
  type        = number
}
variable "publicly_accessible" {
  type        = bool
  default     = false
}
variable "multi_az" {
  description = "Whether to deploy the DB in Multi-AZ mode"
  type        = bool
  default     = false
}
