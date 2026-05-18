provider "aws" {
    region = var.region_aws
}

data "aws_caller_identity" "account" {}
locals {
    account_id = data.aws_caller_identity.account.account_id
}


/*
terraform {
    backend "s3" {
        bucket = "2026-ecomm-back-app-terraform-state-bucket-${var.env_name}"
        key = "abc"
        region = "us-east-1"
        dynamodb_table = "2026-ecomm-back-app-terraform-state-lock-table"
        encrypt = true
    }
}

*/



module "vpc" {
    source = "../../modules/vpc"
    env_name = var.env_name
}


module "ecs" {
    source = "../../modules/ecs"
    env_name = var.env_name
    app_image = "${local.account_id}.dkr.ecr.{var.region_aws}.amazonaws.com/${var.app_name}:dev"
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.public_subnet_ids
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
    auto_shutdown = var.auto_shutdown
    
}

module "lb" {
    source = "../../modules/load_balancer"
    env_name = var.env_name
    vpc_id = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnet_ids
    sg_alb_id = module.sg.sg_alb_id
    alb_logs_bucket = module.s3.alb_logs_bucket_name
}

module "sg" {
    source = "../../modules/security_groups"
    env_name = var.env_name
    vpc_id = module.vpc.vpc_id   
}


module "iam" {
    source = "../../modules/iam"
    env_name = var.env_name
    bucket_name = module.s3.bucket_name

}


module "redis" {
    source = "../../modules/redis"
    env_name = var.env_name
    private_subnet_ids = module.vpc.private_subnet_ids
    redis_sg_id = module.sg.sg_redis_id
}


module "db" {
    source = "../../modules/database"
    env_name = var.env_name
    private_subnet_ids = module.vpc.private_subnet_ids
    db_sg_id = module.sg.sg_db_id
}


module "s3" {
    source = "../../modules/s3"
    env_name = var.env_name
}


module "cloudwatch" {
    source = "../../modules/cloudwatch"
    env_name = var.env_name
    service_name = "ecpmm-back-app"
    cluster_name = "dev-cluster"
    alb_arn_suffix = module.lb.alb_arn_suffix
    region_aws = var.region_aws
    db_instance_id = null
    redis_cluster_id = null

    log_retention_days = 14
    cpu_threshold = 80
}

module "vpc_endpoints" {
    source = "../../modules/vpc_endpoints"
    env_name = var.env_name
    vpc_id = module.vpc.vpc_id
    region_aws = var.region_aws
    private_subnet_ids = module.vpc.private_subnet_ids
    route_table_ids = [module.vpc.private_route_table_id]
    sg_ecs_id = module.sg.sg_ecs_id
    endpoints_sg_id = module.sg.endpoint_sg_id
}


module "monitoring" {
    source = "../../modules/monitoring"
    env_name = var.env_name
    vpc_id = module.vpc.vpc_id
    key_name = var.key_name
    public_subnet_id = module.vpc.public_subnet_ids[0]
    monitoring_sg_id = module.sg.monitoring_sg_id
    instance_type = var.instance_type
    grafana_instance_profile_name = module.iam.grafana_instance_profile_name
}


module "ansible_vars" {
    source = "../../modules/ansible_vars"
    db_instance_id = module.db.db_instance_id
    cluster_name = module.ecs.ecs_cluster_name
    service_name = module.ecs.ecs_service_name
    redis_cluster_id = module.redis.redis_cluster_id
    alb_arn_suffix = module.lb.alb_arn_suffix
    output_path = "${path.module}/ansible/tf_vars.yml"
}


module "lambda" {
    source = "../../modules/lambda"
    lambda_function_name = "${var.env_name}-scheduler"
    lambda_role_arn = module.iam.lambda_role_arn
    shutdown_rule_arn = module.eventbridge.shutdown_rule_arn
    start_rule_arn = module.eventbridge.start_rule_arn
}


module "eventbridge" {
    source = "../../modules/eventbridge"
    lambda_arn = module.lambda.lambda_arn
}
