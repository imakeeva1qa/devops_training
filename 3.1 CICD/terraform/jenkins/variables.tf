variable "region" {
  default = "eu-north-1"
}

variable "repos" {
  type = list
  default = ["fast-api-staging", "fast-api-prod"]
}
