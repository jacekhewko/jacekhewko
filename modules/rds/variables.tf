locals {
  deletion_protection = var.environment == "prod" ? true : false
}

variable "name" {}
variable "environment" {}
variable "storage" { default = 100 }
variable "engine" { default = "postgres" }
variable "ver" { default = "11.8" }
variable "instance_class" {}
variable "parameter_group" { default = "default.postgres11" }
variable "allow_major_version_upgrade" { default = false }
variable "apply_immediately" { default = false }
variable "auto_minor_version_upgrade" { default = false }
variable "backup_retention_period" { default = 30 }
variable "iam_database_authentication_enabled" { default = false }
variable "multi_az" { default = false }
variable "publicly_accessible" { default = false }
variable "snapshot_identifier" { default = null }
variable "iops" { default = 0 }
variable "username" { default = "mysqladm" }
variable "rds_sgs" { type = list(string) }
variable "rds_subnet_ids" { type = list(string) }
variable "db_name" { default = null }

# Alerting
variable "burst_balance_threshold" {
  description = "The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available."
  type        = string
  default     = 20
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = string
  default     = 80
}

variable "cpu_credit_balance_threshold" {
  description = "The minimum number of CPU credits (t2 instances only) available."
  type        = string
  default     = 20
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = string
  default     = 64
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = string
  default     = 64000000

  # 64 Megabyte in Byte
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = string
  default     = 2000000000

  # 2 Gigabyte in Byte
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = string
  default     = 256000000

  # 256 Megabyte in Byte
}

variable "alarm_action" { default = null }
