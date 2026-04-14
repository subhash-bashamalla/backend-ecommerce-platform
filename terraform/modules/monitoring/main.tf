resource "aws_instance" "monitoring_server" {
    instance_type = "t3.micro"
    subnet_id = var.public_subnet_id
    ami = var.ami
    key_name = var.key_name
    vpc_security_group_ids = [var.monitoring_sg_id]

    tags = {
        Name = "${var.env_name}-monitoring-server"
    }
}