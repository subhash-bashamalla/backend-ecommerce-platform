output "redis_endpoint" {
    value = aws_elasticache_cluster.app_cluster.cache_nodes[0].address
}

output "redis_cluster_id" {
    value = aws_elasticache_cluster.app_cluster.id
}