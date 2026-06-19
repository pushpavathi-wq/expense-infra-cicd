terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "dawsfun-expense"
    key = "expense-infra"
    region = "us-east-1"
    dynamodb_table = "remote-expense-dawsfun"   
  }
}


  provider "aws" {
    region = "us-east-1"
    
  }