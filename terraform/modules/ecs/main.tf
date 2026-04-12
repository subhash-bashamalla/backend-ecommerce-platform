resource "aws_ecs_cluster" "app_cluster" {
    name = "${var.env_name}-cluster"
}

resource "aws_ecs_task_definition" "ecomm_app_task_def" {
    family = "${var.env_name}-task"
    cpu = "256"
    memory = "512"
    network_mode = "awsvpc"
    execution_role_arn = var.execution_role_arn
    requires_compatibilities = ["FARGATE"]

    container_definitions = jsonencode([
        {
            name = "ecomm-app"
            image = var.app_image
            essential = true
            portMappings = [
                {
                    containerPort = 5000
                    hostPort = 5000
                }
            ]
        }
    ])
}


resource "aws_ecs_service" "ecomm_app_service" {
    name = "${var.env_name}-service"
    task_definition = aws_ecs_task_definition.ecomm_app_task_def.arn
    cluster = aws_ecs_cluster.app_cluster.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        assign_public_ip = true
        subnets = var.subnets
        security_groups = [var.ecs_sg_id]
    }

    load_balancer {
        target_group_arn = var.tg_arn
        container_name = "app"
        container_port = 6000
    }

    deployment_minimum_healthy_percent = 45
    deployment_maximum_percent = 200

}

