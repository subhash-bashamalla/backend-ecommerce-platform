variable "region_aws" {
    type = string
}

variable "env_name" {
    type = string
}

variable "my_ip" {
    type = string
}

variable "key_name" {
    type = string
}

variable "instance_type" {
    type = string
    default = "t3.medium"
}