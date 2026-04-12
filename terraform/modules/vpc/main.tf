resource "aws_vpc" "vpc_main" {
    cidr_block = "40.0.0.0/16"

    tags = {
        Name = "vpc-main"
    }
}


resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = "us-east-1a"
    cidr_block = "40.0.1.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "public-subnet-1"
    }
}


resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = "us-east-1b"
    cidr_block = "40.0.2.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "public-subnet-2"
    }
}


resource "aws_db_subnet_group" "db_subnet_grp" {
    name = "${var.env_name}-db-subnet-group"
    subnet_ids = var.private_subnets
}