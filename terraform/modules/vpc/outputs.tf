output "vpc_id" {
    value = aws_vpc.ecommerce_app_vpc.id
}

output "cidr_private_subnet" {
    value = aws_subnet.private_subnet.id
}


output "cidr_public_subnet" {
    value = aws_subnet.public_subnet.id
}

