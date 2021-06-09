terraform {
  backend "s3" {
    bucket = "terraformstatebucket-amirzaev"
    key    = "Terraform/terraform-docker/terraform.tfstate"
    region = "us-east-1"
  }

}