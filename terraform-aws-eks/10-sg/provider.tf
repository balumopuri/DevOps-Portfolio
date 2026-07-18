terraform {
  required_version = ">= 1.0"
  required_providers {
    # Add your required providers here
    # Example:
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3"{
    bucket = "terraform-module-expense-eks"
    key = "expense-eks"
    region = "us-east-1"
    dynamodb_table = "bala-terraform-prd"
  }
  }

# Configure the provider
provider "aws" {
  region = "us-east-1"
}
