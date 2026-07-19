terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95"
    }
  }

  backend "s3" {
    bucket         = "terraform-module-expense"
    key            = "expense-app-eks"
    region         = "us-east-1"
    dynamodb_table = "bala-terraform-prd"
  }
}

provider "aws" {
  region = "us-east-1"
}