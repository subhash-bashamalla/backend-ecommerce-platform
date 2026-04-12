resource "aws_cloudwatch_metric_alarm" "cpu_util_ecs_high" {
    alarm_name = "${var.env_name}-${var.service_name}-ecs-cpu-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    statistic = "Average"
    period = 60
    threshold = var.cpu_threshold

    dimensions = {
        ServiceName = var.service_name
        ClusterName = var.cluster_name
    }

    alarm_description = "CPU OF ECS > threshold"
}


resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
    alarm_name = "${var.env_name}-${var.service_name}-ecs-memory-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "MemoryUtilization"
    namespace = "AWS/ECS"
    statistic = "Average"
    period = 60
    threshold = var.memory_threshold

    dimensions = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
    }

    alarm_description = "ECS Memory > threshold"

}


resource "aws_cloudwatch_metric_alarm" "alb_5xx_high" {
    alarm_name = "${var.env_name}-${var.service_name}-alb-5xx-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    metric_name = "HTTPCose_Target_5XX_Count"
    namespace = "AWS/ApplicationELB"
    period = 60
    threshold = 5
    statistic = "Sum"

    dimensions = {
        LoadBalancer = var.alb_arn_suffix
    }
    alarm_description = "ALB 5xx Errors > 5"
}


resource "aws_cloudwatch_metric_alarm" "cpu_rds_high" {
    count = var.db_instance_id == null ? 0 : 1

    alarm_name = "${var.env_name}-rds-cpu-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/RDS"
    period = 60
    threshold = 80
    statistic = "Average"

    dimensions = {
        DBInstanceIdentifier = var.db_instance_id
    }
    alarm_description = "RDS CPU is High"
}


resource "aws_cloudwatch_metric_alarm" "redis_memory_high" {
    count = var.redis_cluster_id == null ? 0 : 1

    alarm_name = "${var.env_name}-redis-memory-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "DatabaseMemoryUsagePercentage"
    namespace = "AWS/ElastiCache"
    period = 60
    threshold = 75
    statistic = "Average"

    dimensions = {
        CacheClusterId = var.redis_cluster_id
    }
    alarm_description = "Redis Memory usage is High"
}