
locals {
  lb_internal = var.lb_internal ? "internal" : "external"
}

variable "environment" {}
variable "name" {}

variable "lb_internal" { default = false }
variable "lb_type" { default = "application" }
variable "lb_sgs" {}
variable "lb_subnets" { type = list(string) }
variable "lb_deletion_protection" { default = true }
