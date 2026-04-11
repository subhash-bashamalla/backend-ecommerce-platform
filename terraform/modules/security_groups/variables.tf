variable "vpc_id" {
    type = string
    description = "The VPC id of which the Security Group belongs"
}

variable "ui_cidr" {
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "CIDR blocks allowed to access UI of Jenkins"
}

variable "agent_cidr" {
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "CIDR blocks allowed to connect to Jenkins agent/s"
}

variable "env_name" {
    type = string  
}