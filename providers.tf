terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket        = "your-terraform-state-bucket"
    key           = "terraform-modules/terraform.tfstate"
    region        = "us-east-1"
    encrypt       = true
    use_lockfile  = true
  }
}

provider "aws" {
  region = var.vpc_region
}
