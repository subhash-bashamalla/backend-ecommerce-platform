variable "region_aws" {
    type = string
    default = "ap-south-1"
    description = "AWS Region in which resources are deployed"
}

variable "cidr_vpc" {
    type = string
    default = ""
    description = "CIDR Block for VPC"
}