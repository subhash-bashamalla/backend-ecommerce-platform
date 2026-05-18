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




resource "aws_cloudwatch_metric_alarm" "high_5xx_burn_rate" {
    alarm_name = "${var.env_name}-high-5xx-burn-rate"
    namespace = "AWS/ApplicationELB"
    alarm_description = "High ALB 5xx error burn rate detected"
    metric_name = "HTTPCode_Target_5XX_Count"
    statistic = "Sum"
    period = 60
    evaluation_periods = 5

    threshold = 20
    comparison_operator = "GreaterThanThreshold"
    treat_missing_data = "notBreaching"

    dimensions = {
        LoadBalancer = var.alb_arn_suffix
    }


    alarm_actions = [
        var.sns_topic_arn
    ]

    ok_actions = [
        var.sns_topic_arn
    ]


    tags = {
        Environment = var.env_name
        Purpose = "BurnRateAlert"
        ManagedBy = "Terraform"
    }
}


resource "aws_cloudwatch_metric_alarm" "high_latency_burn_rate" {
    alarm_name = "${var.env_name}-high-latency-burn-rate"
    alarm_description = "High ALB Latency Burn Rate Detected"
    metric_name = "TargetResponseTime"
    namespace = "AWS/ApplicationELB"

    statistic = "Average"
    period = 60
    evaluation_periods = 5
    threshold = 1


    comparison_operator = "GreaterThanThreshold"
    treat_missing_data = "notBreaching"


    dimensions = {
        LoadBalancer = var.alb_arn_suffix
    }


    alarm_actions = [
        var.sns_topic_arn
    ]

    ok_actions = [
        var.sns_topic_arn
    ]


    tags = {
        Environment = var.env_name
        Purpose = "BurnRateAlert"
        ManagedBy = "Terraform"
    }
}


resource "aws_cloudwatch_metric_alarm" "unhealthy_targets_burn_rate" {
    alarm_name = "${var.env_name}-unhealthy-targets-burn-rate"
    alarm_description = "Unhealthy Targets Detected"
    namespace = "AWS/ApplicationELB"
    metric_name = "UnhealthyHostCount"

    statistic = "Average"
    period = 60
    evaluation_periods = 3
    threshold = 1


    comparison_operator = "GreaterThanOrEqualToThreshold"
    treat_missing_data = "notBreaching"


    dimensions = {
        LoadBalancer = var.alb_arn_suffix
    }

    alarm_actions = [
        var.sns_topic_arn
    ]

    ok_actions = [
        var.sns_topic_arn
    ]


    tags = {
        Environment = var.env_name
        Purpose = "BurnRateAlert"
        ManagedBy = "Terraform"
    }
}


resource "aws_cloudwatch_metric_alarm" "ecs_task_failure_burn_rate" {
    alarm_name = "${var.env_name}-ecs-task-failure-burn-rate"
    alarm_description = "ECS running task count below Desired"
    namespace = "AWS/ECS"
    metric_name = "RunningTaskCount"

    statistic = "Average"
    period = 60
    evaluation_periods = 5
    threshold = 1


    comparison_operator = "LessThanThreshold"
    treat_missing_data = "breaching"


    dimensions = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
    }

    alarm_actions = [
        var.sns_topic_arn
    ]

    ok_actions = [
        var.sns_topic_arn
    ]


    tags = {
        Environment = var.env_name
        Purpose = "BurnRateAlert"
        ManagedBy = "Terraform"
    }
}