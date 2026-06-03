resource "aws_secretsmanager_secret" "db_secret" {
    name = "${var.env_name}-db-secret"

    tags = {
        Environment = var.env_name
        ManagedBy = Terraform
    }
}



resource "aws_secretsmanager_secret_version" "db_secret_version" {
    secret_id = aws_secretsmanager_secret.db_secret.id

    secret_string = jsonencode({
        username = var.db_username
        password = var.db_password
    })
}