resource "aws_sns_topic" "alerts" {
    name = "${var.env_name}-alerts"

    tags = {
        Environment = var.env_name
        ManagedBy = "Terraform"
    }
}


resource "aws_sns_topic_subscription" "email_alerts" {
    topic_arn = aws_sns_topic.alerts.arn
    protocol = "email"
    endpoint = var.email_alert
}