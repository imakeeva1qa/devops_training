module "ecr" {

  source = "git::https://github.com/lgallard/terraform-aws-ecr.git?ref=tags/0.3.2"
  for_each             = toset(var.repos)
  name                 = each.value
  scan_on_push         = true
  timeouts_delete      = "60m"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name            = "ecr-jenkins"
  }
}
