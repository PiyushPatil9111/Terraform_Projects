terraform {
	backend "s3" {
		bucket = "my-terraform-statefiletf--bucket"
    		key = "terraform_project/dev_env/terraform.tfstate"
    		region = "us-east-1"
    		encrypt = true
    		use_lockfile = true
	}
}
