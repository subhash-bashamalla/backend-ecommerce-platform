resource "aws_db_instance" "database_instance" {
    identifier = "${var.env_name}-db"

    instance_class = var.env_name == "production" ? "db.t3.medium" : "db.t3.micro"
    engine = "postgres"
    allocated_storage = 20

    db_subnet_group_name = aws_db_
    vpc_security_group_ids = [var.db_sg_id]
    skip_final_snapshot = true
    publicly_accessible = false
}