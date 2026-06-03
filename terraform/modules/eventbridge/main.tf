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


resource "aws_cloudwatch_event_rule" "rotation" {
    name = "${var.env_name}-db-password-rotation"
    schedule_expression = "rate(15 days)"
}


resource "aws_cloudwatch_event_target" "rotation_target" {
    rule = aws_cloudwatch_event_rule.rotation.name
    arn = var.rotation_lambda_arn

    input = jsonencode({
        secret_arn = var.secret_arn
        db_identifier = var.db_identifier
    })
}

