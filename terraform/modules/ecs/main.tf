resource "aws_ecs_cluster" "main_cluster" {
    name = "main_cluster"
}


resource "aws_ecs_task_definition" "jenkins-master" {
    family = "jenkins-master"
    network_mode = "awsvpc"
    cpu = "512"
    memory = "1024"
    requires_compatibilities = ["FARGATE"]

    container_definitions = jsonencode ([
        {
            name = "jenkins-master"
            image = ""
            portMappings = [
                {
                    containerPort = 8080
                    hostPort = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "jenkins_master_service" {
    name = "jenkins-master-service"
    cluster = aws_ecs_cluster.main_cluster.id
    task_definition = aws_ecs_task_definition.jenkins_master.arn
    launch_type = "FARGATE"
    desired_count = 1

    network_configuration  {
        subnets = module.vpc.public_subnets
        assign_public_ip = true
        security_groups = [module.security_group_jenkins.security_group_jenkins_id]
    }
}


resource "aws_ecs_task_definition" "jenkins_agent" {
    family = "jenkins-agent"
    network_mode = "awsvpc"
    cpu = "512"
    memory = "1024"
    requires_compatibilities = ["FARGATE"]

    container_definitions = jsonencode ([
        {
            name = "jenkins-agent"
            image = ""
            portMappings = [
                {
                containerPort = 50000
                hostPort = 50000
                }
            ]
        }
    ])
}


resource "aws_ecs_service" "jenkins_agent_service" {
    name = "jenkins-agent-service"
    cluster = aws_ecs_cluster.main_cluster.id
    task_definition = aws_ecs_task_definition.jenkins_agent.arn
    launch_type = "FARGATE"
    desired_count = 1

    network_configuration {
        subnets = module.vpc.private_subnets
        security_groups = [module.security_group_jenkins.security_group_jenkins_id]
        assign_public_ip = false
    }
}



resource "aws_ecs_task_definition" "dev_app" {
    family = "dev_app"
    network_mode = "awsvpc"
    cpu = "512"
    memory = "1024"
    requires_compatibilities = ["FARGATE"]


    container_definitions = jsonencode ([
        {
            name = "application_dev"
            image = ""
            portMappings = [
                {
                    containerPort = 8080
                    hostPort = 8080

                }
            ]
        }
    ])
}


resource "aws_ecs_service" "dev_app_service" {
    name = "dev_app_service"
    cluster = aws_ecs_cluster.main_cluster.id
    task_definition = aws_ecs_task_definition.dev_app.arn
    launch_type = "FARGATE"
    desired_count = 1

    network_configuration {
        subnets = module.vpc.private_subnets
        assign_public_ip = true
        security_groups = [module.security_group_jenkins.security_group_jenkins_id]
    }
}


resource "aws_ecs_task_definition" "stage_app" {
    family = "stage_app"
    network_mode = "awsvpc"
    cpu = "512"
    memory = "1024"
    requires_compatibilities = ["FARGATE"]


    container_definitions = jsonencode ([
        {
            name = "application_stage"
            image = ""
            portMappings = [
                {
                    containerPort = 8080
                    hostPort = 8080

                }
            ]
        }
    ])
}


resource "aws_ecs_service" "stage_app_service" {
    name = "stage_app_service"
    cluster = aws_ecs_cluster.main_cluster.id
    task_definition = aws_ecs_task_definition.stage_app.arn
    launch_type = "FARGATE"
    desired_count = 1

    network_configuration {
        subnets = module.vpc.private_subnets
        assign_public_ip = true
        security_groups = [module.security_group_jenkins.security_group_jenkins_id]
    }
}


resource "aws_ecs_task_definition" "prod_app_blue" {
    family = "prod_app_blue"
    network_mode = "awsvpc"
    cpu = "512"
    memory = "1024"
    requires_compatibilities = ["FARGATE"]

    container_definitions = jsonencode ([
        {
            name = "application_prod_blue"
            image = ""
            portMappings = [
                {
                    containerPort = 8080
                    hostPort = 8080
                }
            ]
        }
    ])
}


resource "aws_ecs_service" "prod_app_blue_service" {
    name = "prod_app_blue_service"
    task_definition = aws_ecs_task_definition.prod_app_blue.arn
    cluster = aws_ecs_cluster.main_cluster.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = module.vpc.private_subnets
        assign_public_ip = true
        security_groups = [module.security_group_jenkins.security_group_jenkins_id]
    }
}

resource "aws_ecs_task_definition" "prod_app_green" {
    family = "prod_app_green"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "512"
    memory = "1024"

    container_definitions = jsonencode ([
        {
            name = "application_prod_green"
            image = ""
            portMappings = [
                {
                    containerPort = 8080
                    hostPort = 8080
                }
            ]

        }
    ])
}


resource "aws_ecs_service" "prod_app_green_service" {
    name = "prod_app_green_service"
    cluster = "aws_ecs_cluster.main_cluster.id"
    task_definition = "aws_ecs_task_definition.prod_app_green.arn"
    launch_type = "FARGATE"
    desired_count = 1

    network_configuration {
        subnets = module.vpc.private_subnets
        assign_public_ip = true
        security_groups = [module.security_group_jenkins.security_group_jenkins_id]
    }
}