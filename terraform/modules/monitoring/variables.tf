variable "env_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "ami" {
    type = string
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key_name" {
    type = string
}

variable "my_ip" {
    type = string
}

variable "public_subnet_id" {
    type = string
}

variable "monitoring_sg_id" {
    type = string
}

variable "grafana_instance_profile_name" {
    type = string
}