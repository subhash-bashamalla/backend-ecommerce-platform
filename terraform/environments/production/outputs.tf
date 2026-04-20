output "ecs_cluster_name" {
    value = module.ecs.ecs_cluster_name
}


output "ecs_service_name" {
    value = module.ecs.ecs_service_name
}


output "alb_arn_suffix" {
    value = module.lb.alb_arn_suffix
}


output "db_instance_id" {
    value = module.db.db_instance_id
}