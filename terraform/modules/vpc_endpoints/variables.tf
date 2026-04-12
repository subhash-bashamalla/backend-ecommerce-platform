variable "vpc_id" {
    type = string
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "route_table_ids" {
    type = list(string)
}

variable "region_aws" {
    type = string
}

variable "sg_ecs_id" {
    type = string
}