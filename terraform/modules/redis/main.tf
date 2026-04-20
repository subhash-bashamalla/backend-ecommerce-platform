resource "aws_elasticache_subnet_group" "redis_sub_grp" {
    name = "${var.env_name}-redis-subnet-group"
    subnet_ids = var.private_subnet_ids
}



resource "aws_elasticache_cluster" "app_cluster" {
    cluster_id = "${var.env_name}-redis"
    engine = "redis"
    node_type = var.env_name == "prod" ? "cache.t3.small" : "cache.t3.micro"
    num_cache_nodes = 1

    subnet_group_name = aws_elasticache_subnet_group.redis_sub_grp.name
    security_group_ids = [var.redis_sg_id]
    port = 6379
}