provider "aws" {
    region = var.region_aws
}

module "vpc" {
    source = "./modules/vpc"
    availability_zone = var.availability_zone
    cidr_vpc = var.cidr_vpc
    cidrs_public_subnet = var.cidrs_public_subnet
    cidrs_private_subnet = var.cidrs_private_subnet
}


module "security_group_jenkins" {
    source = "./modules/security_groups"
    vpc_id = module.vpc.vpc_id
}

module "load_balancer" {
    source = "./modules/load_balancer"
    vpc_id = module.vpc.vpc_id
    cidr_range_public_subnet = var.cidrs_range_public_subnet
    security_group_id = module.security_group_jenkins.security_group_jenkins_id
}


module "ecs" {
    source = "./modules/ecs"
    security_group_ids = [module.security_group_jenkins.security_group_jenkins_id]
    

}

