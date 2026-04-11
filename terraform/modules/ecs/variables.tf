variable "env_name" {
    type = string
}

variable "app_image" {
    type = string
}

variable "subnets" {
    type = list(string)
}

variable "ecs_sg_id" {
    type = string
}

variable "tg_arn" {
    type = string
}


variable "alb_sg_id" {
    type = string
}

variable "vpc_id" {
    type = string
}