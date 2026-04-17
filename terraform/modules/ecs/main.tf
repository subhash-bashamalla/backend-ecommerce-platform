resource "aws_ecs_cluster" "app_cluster" {
    name = "${var.env_name}-cluster"
}

resource "aws_ecs_task_definition" "ecomm_app_task_def" {
    family = "${var.env_name}-task"
    cpu = "256"
    memory = "512"
    network_mode = "awsvpc"
    execution_role_arn = var.execution_role_arn
    task_role_arn = var.task_role_name
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

            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-group = var.log_group_name
                    awslogs-region = var.region_aws
                    awslogs-stream-prefix = "ecs"
                }
            }

            environment = [
                {
                    name = "DB_HOST"
                    value = var.db_endpoint
                },
                {
                    name = "DB_NAME"
                    value = "appdb"
                },
                {
                    name = "DB_PORT"
                    value = "5432"
                },
                {
                    name = "DB_USER"
                    value = "postgres"
                },
                {
                    name = "DB_PASSWORD"
                    value = "pw"
                }
            ]


            environment = [
                {
                    name = "REDIS_HOST"
                    value = var.redis_endpoint
                },
                {
                    name = "REDIS_PORT"
                    value = "6379"
                }
            ]


            "healthCheck": {
                "command": ["CMD-SHELL", "curl -f http://localhost:5000/health || exit 1"],
                "interval": 30,
                "timeout": 5,
                "retries": 3,
                "startPeriod": 10
            }
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


resource "aws_appautoscaling_target" "ecs" {
    min_capacity = 1
    max_capacity = 6
    resource_id = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.ecomm_app_service.name}"
    service_namespace = "ecs"
    scalable_dimension = "ecs:service:DesiredCount"
}


resource "aws_appautoscaling_policy" "pol_cpu" {
    name = "ecs-cpu-scaling"
    policy_type = "TargetTrackingScaling"
    resource_id = aws_appautoscaling_target.ecs.resource_id
    scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
    service_namespace = aws_appautoscaling_target.ecs.service_namespace

    target_tracking_scaling_policy_configuration {
        target_value = 60.0

        predefined_metric_specification {
            predefined_metric_type = "ECSServiceAverageCPUUtilization"
        }

        scale_in_cooldown = 60
        scale_out_cooldown = 60
    }
}

