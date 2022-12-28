output "vpc_id" {
  value = data.aws_vpcs.vpc.ids
}

output "public_subnets" {
  value = data.aws_subnets.public_subnets.ids
}

output "private_subnets" {
  value = data.aws_subnets.private_subnets.ids
}

output "security_group" {
  value = data.aws_security_groups.web-sg.ids
}

output "server_ids" {
  value = [for instance in aws_instance.server : instance.id]
}
