locals {
    fifo_name = var.fifo_queue ? ".fifo" : null
}

variable "name" {}
variable "env" {}

variable "delay_seconds" { default = 90 }
variable "max_message_size" { default = 262144 }
variable "message_retention_seconds" { default = 86400 }
variable "receive_wait_time_seconds" { default = 10 }
variable "redrive_policy" { default = null }
variable "redrive_allow_policy" { default = null }
variable "fifo_queue" { default = false }
variable "content_based_deduplication" { default = null }
variable "deduplication_scope" { default = null }
variable "fifo_throughput_limit" { default = null }
variable "sqs_managed_sse_enabled" { default = true }

variable "sqs_user_arn" { default = null }