output "ecs_cluster_name" {
    value = {
        for env, mod in module.ecs :
        env => mod.ecs_cluster_name
    }
}


output "ecs_service_name" {
    value = {
        for env, mod in module.ecs :
        env => mod.ecs_service_name
    }
}


output "alb_arn_suffix" {
    value = {
        for env, mod in module.lb :
        env => mod.alb_arn_suffix
    }
}


output "db_instance_id" {
    value = {
        for env, mod in module.db :
        env => mod.db_instance_id
    }
}