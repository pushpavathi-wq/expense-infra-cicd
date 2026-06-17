# /* output "public-subnets" {
#     value = aws_cidr_publicsubnet
  
# } */

# If a value is not exposed in developer module(should be specified in outputs), we cant access it from test module 
  


  output "vpc_id" {
    value = module.vpc.vpc_id
  
}


output "public_subnet_ids" {
    value = module.vpc.public_subnet_ids  # * is used to print all subnets
  
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
  
}


output "public_database_ids" {
    value = module.vpc.public_database_ids
  
}