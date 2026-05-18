resource "local_file" "ansible_vars" {
    content = yamlencode({
        service_name = var.cluster_name
        cluster_name = var.cluster_name
        db_instance_id = var.db_instance_id
        redis_cluster_id = var.redis_cluster_id
        alb_arn_suffix = var.alb_arn_suffix
    })
    filename = var.output_path
}