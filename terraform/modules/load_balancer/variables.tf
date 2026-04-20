variable "vpc_id" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "sg_alb_id" {
    type = string
}

variable "env_name" {
    type = string
}

variable "alb_logs_bucket" {
    type = string
}
