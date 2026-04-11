provider "aws" {
    region = var.region_aws
}
/*
terraform {
    backend "s3" {
        bucket = "2026-ecomm-back-app-terraform-state-bucket"
        key = "abc"
        region = "us-east-1"
        dynamodb_table = "2026-ecomm-back-app-terraform-state-lock-table"
        encrypt = true
    }
}

*/



module "vpc" {
    source = "./modules/vpc"
}


module "ecs_dev" {
    source = "./modules/ecs"
    env_name = "dev"
    app_image = "${var.account_id}.dkr.ecr.{var.region_aws}.amazonaws.com/${var.app_name}:dev"
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.public_subnets
    alb_sg_id = module.sg_dev.sg_alb_id
    ecs_sg_id = module.sg_dev.sg_ecs_id
    tg_arn = module.lb_dev.tg_arn
    
}

module "lb_dev" {
    source = "./modules/load_balancer"
    env_name = "dev"
    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnets
    sg_alb_id = module.sg_dev.sg_alb_id
}

module "sg_dev" {
    source = "./modules/security_groups"
    env_name = "dev"
    vpc_id = module.vpc.vpc_id   
}







