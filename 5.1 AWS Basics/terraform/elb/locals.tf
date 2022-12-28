locals {
  tags = {
    Project    = var.project
    Service    = var.service_name
  }
  vpc_id = data.aws_vpcs.vpc.ids[0]
}
