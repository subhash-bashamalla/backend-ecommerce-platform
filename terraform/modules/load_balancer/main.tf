resource "aws_lb" "lb_app" {
    name = "lb_app"
    load_balancer_type = "application"
    internal = false
    security_groups = [var.security_group_id]
    subnets = var.public_subnets
}

resource  "aws_lb_target_group" "tg_dev_app" {
    name = "tg_dev_app"
    port = 8080
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = "/"
        timeout = 10
        healthy_threshold = 3
        unhealthy_threshold = 3
        interval = 45
        matcher = "250"
    }
}


resource  "aws_lb_target_group" "tg_stage_app" {
    name = "tg_stage_app"
    port = 8080
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = "/"
        timeout = 10
        healthy_threshold = 3
        unhealthy_threshold = 3
        interval = 45
        matcher = "250"
    }
}


resource  "aws_lb_target_group" "tg_prod_app_blue" {
    name = "tg_prod_app_blue"
    port = 8080
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = "/"
        timeout = 10
        healthy_threshold = 3
        unhealthy_threshold = 3
        interval = 45
        matcher = "250"
    }
}


resource  "aws_lb_target_group" "tg_prod_app_green" {
    name = "tg_prod_app_green"
    port = 8080
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = "/"
        timeout = 10
        healthy_threshold = 3
        unhealthy_threshold = 3
        interval = 45
        matcher = "250"
    }
}


resource "aws_lb_listener" "http_listener" {
    port = 80
    protocol = "HTTP"
    load_balancer_arn = aws_lb.lb_app.arn

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_app.arn
    }
}


output "alb_dns_name" {
    value = aws_lb.lb_app.dns_name
}