terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    managed_by        = "terraform"
    terraform_project = "aws-minecraft"
  }
}
