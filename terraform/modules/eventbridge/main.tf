resource "aws_cloudwatch_event_rule" "start_rule" {
    name = "weekday-start"
    schedule_expression = "cron(30 3 ? * MON-FRI *)"
}


resource "aws_cloudwatch_event_rule" "shutdown_rule" {
    name = "weekday-shutdown"
    schedule_expression = "cron(30 11 ? * MON-FRI *)"
}


resource "aws_cloudwatch_event_target" "start_target" {
    rule = aws_cloudwatch_event_rule.start_rule.name
    arn = var.lambda_arn
    input = jsonencode({
        action = "start"
    })
}


resource "aws_cloudwatch_event_target" "shutdown_target" {
    rule = aws_cloudwatch_event_rule.shutdown_rule.name
    arn = var.lambda_arn
    input = jsonencode({
        action = "stop"
    })
}

