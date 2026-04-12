variable "env_name" {
    type = string
}

variable "service_name" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "cpu_threshold" {
    type = number
    default = 80
}

variable "log_retention_days" {
    default = 14
    type = number
}

variable "memory_threshold" {
    type = number
    default = 80
}

variable "region_aws" {
    type = string
}

variable "alb_arn_suffix" {
    type = string
}

variable "db_instance_id" {
    default = null
    type = string
}

variable "redis_cluster_id" {
    default = null
    type = string
}