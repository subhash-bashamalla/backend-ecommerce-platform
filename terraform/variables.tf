variable "region_aws" {
    type = string
    default = "ap-south-1"
    description = "AWS Region in which resources are deployed"
}

variable "availability_zone" {
    type = list(string)
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    description = "AZ in which resource/s will be deployed"
}

variable "cidr_vpc" {
    type = string
    default = ""
    description = "CIDR Block for VPC"
}

variable "cidr_public_subnet_1" {
    type = string
    default = ""
    description = "CIDR block for Public Subnet"
}

variable "cidr_private_subnet_1" {
    type = string
    default = ""
    description = "CIDR block for Private Subnet"
}