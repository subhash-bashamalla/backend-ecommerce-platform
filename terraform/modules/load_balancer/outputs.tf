output "alb_dns" {
    value = aws_lb.ecomm-back-app.dns_name
}

output "tg_arn" {
    value = aws_lb_target_group.ecomm-back-app.arn
}