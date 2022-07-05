locals {
  azone-list     = ["a", "b", "c"]
  azones         = [for az in local.azone-list : "${data.aws_region.current.name}${az}"]
  azones-public  = [for az in local.azone-list : "${var.name}-public-${az}"]
  azones-private = [for az in local.azone-list : "${var.name}-private-${az}"]
}

variable "name" {}
variable "environment" {}
variable "first_cidr_block" { default = "10" }
variable "second_cidr_block" { default = "10" }
