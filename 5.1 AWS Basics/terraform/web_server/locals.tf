locals {
  tags = {
    Project = var.project
    Service = var.service_name
  }
  bucket_list_mod_1      = [for s in var.bucket_list : "arn:aws:s3:::${s}"]
  bucket_list_mod_2      = [for s in var.bucket_list : "arn:aws:s3:::${s}/*"]
  bucket_list_mod_merged = concat(local.bucket_list_mod_1, local.bucket_list_mod_2)
}
