resource "aws_security_group" "security_group_jenkins" {
    name = "security_group_jenkins"
    vpc_id = var.vpc_id
    description = "Security groups for Master and Agent"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = var.ui_cidr
        description = "Allow access to Jenkins UI"
    }

    ingress {
        from_port = 50000
        to_port = 50000
        protocol = "tcp"
        cidr_blocks = var.agent_cidr
        description = "Allow access from Jenkins Agent"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH access from anywhere"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }
}

output "security_group_jenkins_id" {
    value = aws_security_group.security_group_jenkins.id
}