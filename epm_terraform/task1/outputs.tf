output "default_vpc_id" {
  description = "A list of all the VPC ids found"
  value = data.aws_vpcs.default.ids
}

output "default_subnet_id" {
  description = "A list of all the subnet ids found"
  value = data.aws_subnets.default.ids
}

output "default_sg_id" {
  description = "IDs of the matches security groups"
  value = data.aws_security_groups.default.ids
}
