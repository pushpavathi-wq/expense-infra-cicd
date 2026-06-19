# vpc id stored in parameter store,pull it using data sources

data "aws_ssm_parameter" "vpc_id" {
  name = "/expense/dev/vpc_id"
}