resource "aws_vpc" "vpc_main" {
    cidr_block = "40.0.0.0/16"

    tags = {
        Name = "vpc-main"
    }
}


locals {
    public_subnets = {
        az1 = {
            az = "us-east-1a"
            cidr = "40.0.1.0/24"
        }
        az2 = {
            az = "us-east-1b"
            cidr = "40.0.2.0/24"
        }
    }

    private_subnets = {
        az1 = {
            az = "us-east-1a"
            cidr = "40.0.3.0/24"
        }
        az2 = {
            az = "us-east-1b"
            cidr = "40.0.4.0/24"
        }
    }
}


resource "aws_subnet" "public_subnets" {
    for_each = local.public_subnets
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = each.value.az
    cidr_block = each.value.cidr
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.env_name}-public-${each.key}"
    }
}


resource "aws_subnet" "private_subnets" {
    for_each = local.private_subnets
    vpc_id = aws_vpc.vpc_main.id
    availability_zone = each.value.az
    cidr_block = each.value.cidr
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.env_name}-private-${each.key}"
    }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc_main.id

    tags = {
        Name = "${var.env_name}-igw"
    }
}


resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc_main.id

    tags = {
        Name = "${var.env_name}-public-rt"
    }
}


resource "aws_route" "public_internet" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public_rta" {
    for_each = aws_subnet.public_subnets

    subnet_id = each.value.id
    route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc_main.id

    tags = {
        Name = "${var.env_name}-private-rt"
    }
}


resource "aws_route_table_association" "private_rta" {
    for_each = aws_subnet.private_subnets

    subnet_id = each.value.id
    route_table_id = aws_route_table.private_rt.id
}


resource "aws_db_subnet_group" "db_subnet_grp" {
    name = "${var.env_name}-db-subnet-group"
    subnet_ids = var.private_subnets
}