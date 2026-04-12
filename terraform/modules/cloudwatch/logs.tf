resource "aws_cloudwatch_log_group" "ecs" {
    name = "/ecs/${var.env_name}/${var.service_name}"
    retention_in_days = var.log_retention_days

    tags = {
        Environment = var.env_name
        Service = var.service_name
    }
}