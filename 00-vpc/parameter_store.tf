resource "aws_ssm_parameter" "expense-vpc-id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

# create the parameter store and store the VPC id
# If the VPC id is not provided in main module output we cant access here in user module.. 
# we just give the CIDR for the VPC,VPC id is created after creating vpc. 

# stote public subnets in parameter store
resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
  }


# stote private subnets in parameter store
resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"   # option shown while creating paramerstore in SSM , it joins multiple subnets using ,seperator
  value = join(",", module.vpc.private_subnet_ids)
  }


# stote database subnets in parameter store
resource "aws_ssm_parameter" "public_database_ids" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_database_ids)
  }    