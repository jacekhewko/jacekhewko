locals {
  image_id  = var.cis ? data.aws_ami.cis.id : var.image_id
#  user_data = var.cis ? "${path.module}/cis.sh" : var.user_data
}

variable "env" {}
variable "cis" { default = true }
variable "image_id" { default = null }
variable "instance_type" {}
variable "security_groups" { type = list(string) }
variable "vol_size" { default = 20 }
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}
variable "asg_subnets" { type = list(string) }
variable "cluster_name" {}
variable "aws_ami" { default = "CIS Amazon Linux 2 Benchmark v1.0.0.12 - level 1*" }
