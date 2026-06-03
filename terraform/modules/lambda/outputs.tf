output "lambda_arn" {
    value = aws_lambda_function.scheduler.arn
}

output "rotation_lambda_name" {
    value = aws_lambda_function.rotation.function_name
}

output "rotation_lambda_arn" {
    value = aws_lambda_function.rotation.arn
}