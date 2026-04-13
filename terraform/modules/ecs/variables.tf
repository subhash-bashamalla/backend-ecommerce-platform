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

variable "execution_role_arn" {
    type = string
}

variable "task_role_arn" {
    type = string
}

variable "bucket_name" {
    type = string
}

variable "log_group_name" {
    type = string
}

variable "region_aws" {
    type = string
}

variable "db_endpoint" {
    type = string
}

variable "redis_endpoint" {
    type = string
}