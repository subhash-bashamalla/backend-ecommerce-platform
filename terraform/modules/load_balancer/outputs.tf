output "alb_dns" {
    value = aws_lb.ecomm_back_app.dns_name
}

output "tg_arn" {
    value = aws_lb_target_group.ecomm-back-app.arn
}

output "alb_arn_suffix" {
    value = aws_lb.ecomm_back_app.arn_suffix
}