output "ecs_cluster_name" {
    value = aws_ecs_cluster.app_cluster.name
}

output "ecs_service_name" {
    value = aws_ecs_service.ecomm_app_service.name
}

output "alb_arn_suffix" {
    value = aws_lb.ecomm_back_app.arn_suffix
}

output "db_instance_id" {
    value = aws_db_instance.database_instance.id
}