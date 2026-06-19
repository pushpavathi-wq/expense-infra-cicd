terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.84.1"
    }
  }

    backend "s3" {
    bucket         = "expense-infra-remote-states"
    key            = "eks-bastion-state-file"
    region         = "us-east-1"
    dynamodb_table = "expense-infra-dev-table"
    }
}




provider "aws" {
    region = "us-east-1"
  
}