provider "aws" {
    region = var.region_aws
}

data "http" "my-ip" {
    url = "https://checkip.amazonaws.com"
}


data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}


resource "aws_iam_role" "jenkins_role" {
    name = "${var.env_name}-jenkins-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }

            Action = "sts:AssumeRole"
        }]
    })
}


resource "aws_iam_role_policy_attachment" "ecr_pol_attach"  {
    role = aws_iam_role.jenkins_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}


resource "aws_iam_role_policy_attachment" "ecs_pol_attach" {
    role = aws_iam_role.jenkins_role
    policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}


resource "aws_security_group" "jenkins_sg" {
    name = "${var.env_name}-jenkins-sg"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_iam_instance_profile" "jenkins_profile" {
    name = "${var.env_name}-jenkins-profile"
    role = aws_iam_role.jenkins_role.name
}


resource "aws_instance" "jenkins" {
    instance_type = var.instance_type
    ami = data.aws_ami.amazon_linux
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name
    user_data = file("${path.module}/userdata.sh")

    tags = {
        Name = "{var.env_name}-jenkins"
    }
}