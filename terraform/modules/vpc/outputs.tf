output "vpc_id" {
    value = aws_vpc.vpc_main.id
}

output "public_subnets" {
    value = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id
    ]
}





