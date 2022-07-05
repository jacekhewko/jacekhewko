variable "cluster_id" {}

variable "env" {}

variable "engine" {
    default = "redis"
}

variable "node_type" {
    default = "cache.t3.micro"
}

variable "num_cache_nodes" {
    default = 1
}

variable "port" {
    default = 6379
}

variable "apply_immediately" {
    default = true
}

variable "subnet_ids" {
    type = list
}

variable "security_group_ids" {
    type = list
}
