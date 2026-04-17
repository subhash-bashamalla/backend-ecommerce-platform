variable "region_aws" {
    type = string
    default = "us-east-1"
    description = "AWS Region in which resources are deployed"
}

variable "avail_zone" {
    type = list(string)
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
    description = "AZ in which resource/s will be deployed"
}


variable "env_name" {
    description = "Environment name for which resource is created"
    type = string
    default = "development"
}

variable "account_id" {
    description = "AWS Account Id"
    type = string
}

variable "app_name" {
    type = string
    description = "Application image for ECR Image"
    default = "backend-ecommerce-platform"
}

variable "ami" {
    type = string
}

variable "key_name" {
    type = string
}

variable "my_ip" {
    type = string
}