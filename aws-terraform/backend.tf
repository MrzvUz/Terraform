terraform {
  backend "remote" {
    organization = "amirzaev-terraform"

    workspaces {
      name = "aws-dev"
    }
  }
}