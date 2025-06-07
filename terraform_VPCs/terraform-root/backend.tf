terraform {
	backend "s3" {
		bucket = "my-terraform-statefiletf--bucket"
    		key = "terra_project/vpc_root/terraform.tfstate"
    		region = "us-east-1"
    		encrypt = true
    		use_lockfile = true
	}
}
