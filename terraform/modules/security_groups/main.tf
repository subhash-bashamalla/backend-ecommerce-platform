resource "aws_security_group" "sg_alb" {
    name = "alb-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "sg_ecs" {
    name = "ecs-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 6000
        to_port = 6000
        protocol = "tcp"
        cidr_blocks = [aws_security_group.sg_alb.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "sg_db" {
    name = "db-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = [aws_security_group.sg_ecs.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group_rule" "ecs_to_db" {
    type = "ingress"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"

    security_group_id = aws_security_group.sg_db.id
    source_security_group_id = aws_security_group.sg_ecs.id
}


resource "aws_security_group" "sg_redis" {
    name = "redis-sg"
    vpc_id = var.vpc_id
}


resource "aws_security_group_rule" "ecs_to_redis" {
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"

    source_security_group_id = aws_security_group.sg_ecs.id
    security_group_id = aws_security_group.sg_redis.id
}


resource "aws_security_group" "endpoints_sg" {
    name = "endpoints-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        security_groups = [var.sg_ecs.id]
    }
}