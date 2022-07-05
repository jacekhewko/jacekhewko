output "redis_arn" { value = aws_elasticache_cluster.main.arn }
output "cache_nodes" { value = aws_elasticache_cluster.main.cache_nodes }
output "cluster_address" { value = aws_elasticache_cluster.main.cluster_address }
output "redis_address" { value = element(aws_elasticache_cluster.main.cache_nodes[*].address, 1)}
