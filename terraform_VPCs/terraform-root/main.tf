module "vpc_project" {
  source = "../terraform-vpc-project"
}

module "vpc_peering" {
  source = "../terraform-vpc-peering"
}
