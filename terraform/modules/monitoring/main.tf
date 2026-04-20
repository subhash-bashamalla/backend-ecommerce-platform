data "aws_ami" "amazon_linux" {
    owners = ["amazon"]
    most_recent = true

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}


resource "aws_instance" "monitoring_server" {
    instance_type = var.instance_type
    subnet_id = var.public_subnet_id
    ami = data.aws_ami.amazon_linux.id
    key_name = var.key_name
    vpc_security_group_ids = [var.monitoring_sg_id]
    iam_instance_profile = var.grafana_instance_profile_name

    tags = {
        Name = "${var.env_name}-monitoring-server"
    }
}
