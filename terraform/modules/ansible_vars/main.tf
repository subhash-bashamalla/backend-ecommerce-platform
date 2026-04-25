resource "local_file" "ansible_vars" {
    content = yamlencode({
        service_name = var.cluster_name
        cluster_name = var.cluster_name
        db_instance_id = var.db_instance_id
    })
    filename = var.output_path
}