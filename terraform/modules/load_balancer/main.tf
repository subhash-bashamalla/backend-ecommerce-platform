resource "aws_lb" "ecomm-back-app" {
    name = "${var.env_name}-alb"
    subnets = var.public_subnets
    security_groups = [var.sg_alb_id]
    load_balancer_type = "application"

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
    }
}


resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.ecomm-back-app.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.ecomm-back-app.arn
    }
}