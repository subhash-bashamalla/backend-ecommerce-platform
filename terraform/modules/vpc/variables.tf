variable "availability_zone" {
    type = string
    default = "ap-south-1a"
    description = "AZ in which resource/s will be deployed"
}

variable "cidr_vpc" {
    type = string
    default = "10.0.0.0/16"
    description = "CIDR block for the VPC"
}

variable "cidr_range_public_subnet" {
    type = string
    default = "10.0.1.0/24"
    description = "Public subnet CIDR block"
}


variable "cidrs_public_subnet" {
    type = list(string)
    description = "Public Subnet - List of CIDR blocks"
}


variable "cidr_range_private_subnet" {
    type = string
    default = "10.0.2.0/24"
    description = "Private subnet CIDR block"
}


variable "cidrs_private_subnet" {
    type = list(string)
    description = "Private Subnet - List of CIDR blocks"
}