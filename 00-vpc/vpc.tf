module "vpc" {
  source = "git::https://github.com/pushpavathi-wq/Terraform.git//Terraform_vpc_module?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags      # just we are putting common tags in 1 variable
  vpc_cidr   = var.vpc_cidr     # variable from test module variable
  cidr_publicsubnet = var.cidr_public   # variable from test module
  cidr_privatesubnet = var.cidr_private
  cidr_databasesubnet = var.cidr_database
  



}


