variable "repository_name" {
  type        = string
  description = "Name of the repository"
}

variable "image_scan" {
  default = "false"
  type    = string
}

variable "env" {
}
