variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
variable "internal" {
  type = bool
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}

