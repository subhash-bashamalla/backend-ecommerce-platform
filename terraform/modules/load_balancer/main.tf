resource "aws_lb" "ecomm_back_app" {
    name = "${var.env_name}-alb"
    subnets = var.public_subnet_ids
    security_groups = [var.sg_alb_id]
    load_balancer_type = "application"

    access_logs {
        bucket = var.alb_logs_bucket
        enabled = true
    }

    tags = {
        Name = "${var.env_name}-alb"
    }
}



resource "aws_lb_target_group" "ecomm-back-app" {
    name = "${var.env_name}-tg"
    port = 6000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = var.vpc_id

    health_check {
        path = "/health"
        interval = 45
        timeout = 10
        healthy_threshold = 2
        unhealthy_threshold = 2
        matcher = "200"
    }
}


resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.ecomm_back_app.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.ecomm-back-app.arn
    }
}

/*
resource "aws_acm_certificate" "certificate" {
    domain_mname = ""
    validation_method = "DNS"
}


resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.ecomm-back-app.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certification_arn = aws_acm_certificate.certificate.arn
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.ecomm-back-app.arn
    }
}

*/