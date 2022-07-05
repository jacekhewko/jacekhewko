locals {
  s3_force_destroy = var.environment == "prod" ? false : true
  storage_bucket   = var.storage_bucket == true ? 1 : 0
}

variable "environment" {}
variable "name" {}
variable "vpc_id" {}
variable "domain" { default = null }
variable "task_def" { default = "default" }
variable "cpu" { default = null }
variable "memory" { default = null }
variable "image" {}
variable "healthcheck_path" { default = "/" }
variable "log_retention" { default = 7 }
variable "cluster" {}
variable "desired_count" {}
variable "ecs_subnet_ids" {}
variable "ecs_security_groups" {}
variable "container_port" { default = 80 }
variable "ssl" { default = true }
variable "certificate_arn" { default = null }
variable "storage_bucket" { default = false }
variable "target_group" { default = false }
variable "listener_path_pattern" { default = null }

variable "high_cpu" { default = 80 }
variable "high_mem" { default = 80 }

variable "alarm_action" { default = null }

variable "min_capacity" { default = 1 }
variable "max_capacity" { default = 1 }

variable "low_cpu" { default = 10 }
variable "low_mem" { default = 30 }

variable "target_3xx_count_threshold" {
  type        = number
  description = "The maximum count of 3XX requests over a period. A negative value will disable the alert"
  default     = 25
}

variable "target_4xx_count_threshold" {
  type        = number
  description = "The maximum count of 4XX requests over a period. A negative value will disable the alert"
  default     = 25
}

variable "target_5xx_count_threshold" {
  type        = number
  description = "The maximum count of 5XX requests over a period. A negative value will disable the alert"
  default     = 25
}

variable "elb_5xx_count_threshold" {
  type        = number
  description = "The maximum count of ELB 5XX requests over a period. A negative value will disable the alert"
  default     = 25
}

variable "target_response_time_threshold" {
  type        = number
  description = "The maximum average target response time (in seconds) over a period. A negative value will disable the alert"
  default     = 0.5
}
