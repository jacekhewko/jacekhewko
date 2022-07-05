resource "aws_elasticache_subnet_group" "main" {
  name       = var.cluster_id
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "main" {
  cluster_id        = var.cluster_id
  engine            = var.engine
  node_type         = var.node_type
  num_cache_nodes   = var.num_cache_nodes
  port              = var.port
  apply_immediately = var.apply_immediately
  security_group_ids = var.security_group_ids
  subnet_group_name = aws_elasticache_subnet_group.main.name

#   log_delivery_configuration {
#     destination      = aws_cloudwatch_log_group.example.name
#     destination_type = "cloudwatch-logs"
#     log_format       = "text"
#     log_type         = "slow-log"
#   }
}
