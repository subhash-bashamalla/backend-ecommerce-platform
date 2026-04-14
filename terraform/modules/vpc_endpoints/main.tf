resource "aws_vpc_endpoint" "s3" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region_aws}.s3"
    route_table_ids = var.route_table_ids
    vpc_endpoint_type = "Gateway"

    tags = {
        Name = "${var.env_name}-s3-endpoint"
    }
}


resource "aws_vpc_endpoint" "ecr_api" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region_aws}.ecr.api"
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.endpoints_sg.id]
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true

    tags = {
        Name = "${var.env_name}-ecr-api-endpoint"
    }
}


resource "aws_vpc_endpoint" "ecr_dkr" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region_aws}.ecr.dkr"
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.endpoints_sg.id]
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true

    tags = {
        Name = "${var.env_name}-ecr-dkr-endpoint"
    }
}


resource "aws_vpc_endpoint" "logs" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region_aws}.logs"
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.endpoints_sg.id]
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true

    tags = {
        Name = "${var.env_name}-logs-endpoint"
    }
}