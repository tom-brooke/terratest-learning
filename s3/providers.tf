terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.role_arn
  }
}

terraform {
  required_version = ">= 1.2.8"

  # TODO - replace!!!
  backend "local" {
    path = "terraform.tfstate"
  }
  # backend "s3" {
  #   region         = "eu-west-2"
  #   key            = "terratest.tfstate"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock-table"
  # }
}
