variable "vpc_id" {
    type = string
}

variable "public_subnets" {
    type = list(string)
}

variable "sg_alb_id" {
    type = string
}

variable "env_name" {
    type = string
}
