variable "region_aws" {
    type = string
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
}


variable "app_name" {
    type = string
    description = "Application image for ECR Image"
}


variable "key_name" {
    type = string
}

variable "instance_type" {
    type = string
}
