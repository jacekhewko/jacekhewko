resource "aws_ssm_parameter" "redis-address" {
  name        = "/${var.env}/redis/${var.cluster_id}/address"
  description = "Redis address"
  type        = "SecureString"
  value       = element(aws_elasticache_cluster.main.cache_nodes[*].address, 1)
  overwrite   = true

  tags = {
    environment = var.env
    managed_by  = "terraform"
  }
}


