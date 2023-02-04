provider "aws" {
  region = "eu-central-1"
}
# data sources 
data "aws_vpcs" "default" {}
data "aws_subnets" "default" {}
data "aws_security_groups" "default" {}
