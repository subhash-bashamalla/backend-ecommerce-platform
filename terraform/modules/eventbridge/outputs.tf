output "start_rule_arn" {
    value = aws_cloudwatch_event_rule.start_rule.arn
}

output "shutdown_rule_arn" {
    value = aws_cloudwatch_event_rule.shutdown_rule.arn
}