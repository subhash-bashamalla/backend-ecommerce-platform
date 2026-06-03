data "archive_file" "scheduler_lambda_zip" {
    type = "zip"
    source_file = "${path.module}/lambda/scheduler.py"
    output_path = "${path.module}/lambda/scheduler.zip"
}




resource "aws_lambda_function" "scheduler" {
    function_name = var.lambda_function_name
    role = var.lambda_role_arn
    runtime = "python3.12"
    handler = "scheduler.lambda_handler"
    source_code_hash = data.archive_file.scheduler_zip.output_base64sha256
    filename = data.archive_file.scheduler_zip.output_path
    timeout = 30
}


resource "aws_lambda_permission" "start_allow" {
    statement_id = "AllowStartupInvoke"
    function_name = aws_lambda_function.scheduler.function_name
    action = "lambda:InvokeFunction"
    principal = "events.amazonaws.com"
    source_arn = var.start_rule_arn
}


resource "aws_lambda_permission" "shutdown_allow" {
    statement_id = "AllowShutdownInvoke"
    function_name = aws_lambda_function.scheduler.function_name
    action = "lambda:InvokeFunction"
    principal = "events.amazonaws.com"
    source_arn = var.shutdown_rule_arn
}


resource "aws_lambda_function" "rotation" {
    function_name = "${var.env_name}-rds-password-rotation"

    filename = data.archive_file.rotation.output_path
    source_code_hash = data.archive_file.rotation.output_base64sha256

    role = var.lambda_role_arn
    handler = "rds_password_rotation.lambda_handler"
    runtime = "python3.12"

    timeout = 60
}


resource "aws_lambda_permission" "rotation_allow" {
    statement_id = "AllowEventBridgeInvokeRotation"
    action = "lambda:InvokeFunction"

    function_name = aws_lambda_function.rotation.function_name
    principal = "events.amazonaws.com"
    source_arn = var.rotation_rule_arn
}

