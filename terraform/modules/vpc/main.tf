resource "aws_vpc" "ecommerce_app_vpc" {
    cidr_block = var.cidr_vpc
    tags = {
        Name = "ecommerce_app_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.ecommerce_app_vpc.id
    count = length(var.cidrs_public_subnet)
    cidr_block = var.cidrs_public_subnet[count.index]
    availability_zone = var.availability_zone[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet-${count.index}"
    }
}


resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.ecommerce_app_vpc.id
    count = length(var.cidrs_private_subnet)
    cidr_block = var.cidrs_private_subnet[count.index]
    availability_zone = var.availability_zone[count.index]
    tags = {
        Name = "private_subnet-${count.index}"
    }
}


resource "aws_internet_gateway" "int_gateway" {
    vpc_id = aws_vpc.ecommerce_app_vpc.id
    tags = {
        Name = "int-gateway"
    }
}