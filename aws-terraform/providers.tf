# --- root/providers.tf ---
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region # pulls aws region info from root/variables.tf aws_region variable.
}