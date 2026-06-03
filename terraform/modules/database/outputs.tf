output "db_endpoint" {
    value = aws_db_instance.database_instance.endpoint
}


output "db_instance_id" {
    value = aws_db_instance.database_instance.id
}

output "db_identifier" {
    value = aws_db_instance.database_instance.identifier
}