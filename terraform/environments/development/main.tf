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


module "ecs" {
    source = "../../modules/ecs"
    env_name = "development"
    app_image = "${var.account_id}.dkr.ecr.{var.region_aws}.amazonaws.com/${var.app_name}:dev"
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.public_subnets
    alb_sg_id = module.sg.sg_alb_id
    ecs_sg_id = module.sg.sg_ecs_id
    tg_arn = module.lb.tg_arn
    task_role_arn = module.iam.ecs_task_role_arn
    task_role_name = module.iam.ecs_task_role_name
    execution_role_arn = module.iam.ecs_execution_role_arn
    log_group_name = module.cloudwatch.log_group_name
    region_aws = var.region_aws
    bucket_name = module.s3.bucket_name
    db_endpoint = module.db.db_endpoint
    redis_endpoint = module.redis.redis_endpoint
    
}

module "lb" {
    source = "../../modules/load_balancer"
    env_name = "development"
    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnets
    sg_alb_id = module.sg.sg_alb_id
}

module "sg" {
    source = "../../modules/security_groups"
    env_name = "development"
    vpc_id = module.vpc.vpc_id   
}


module "iam" {
    source = "../../modules/iam"
    env_name = "development"
    vpc_id = module.vpc.vpc_id

}


module "redis" {
    source = "../../modules/redis"
    env_name = "development"
    private_subnets = module.vpc.private_subnets
    redis_sg_id = module.sg.sg_redis_id
}


module "db" {
    source = "../../modules/database"
    env_name = "development"
    private_subnets = module.vpc.private_subnets
    db_sg_id = module.sg.sg_db_id
}


module "s3" {
    source = "../../modules/s3"
    env_name = "development"
}


module "cloudwatch" {
    source = "../../modules/cloudwatch"
    env_name = "development"
    service_name = "ecpmm-back-app"
    cluster_name = "dev-cluster"
    alb_arn_suffix = module.lb.arn_suffix
    region_aws = var.region_aws
    db_instance_id = null
    redis_cluster_id = null

    log_retention_days = 14
    cpu_threshold = 80
}

module "vpc_endpoints" {
    source = "../../modules/vpc_endpoints"
    vpc_id = module.vpc.vpc_id
    region_aws = var.region_aws
    private_subnet_ids = module.vpc.private_subnet_ids
    route_table_ids = [module.vpc.private_route_table_id]
    sg_ecs_id = module.sg.sg_ecs_id
}







