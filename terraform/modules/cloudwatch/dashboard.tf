resource "aws_cloudwatch_dashboard" "main_dash" {
    dashboard_name = "${var.env_name}-${var.service_name}-dashboard"

    dashboard_body = jsonencode({
        widgets = [
            {
                type = "metric"
                properties = {
                    title = "CPU ECS"
                    region = var.region_aws
                    metrics = [
                        ["AWS/ECS", "CPUUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name]
                    ]
                    period = 60
                    stat = "Average"
                }
            },

            {
                type = "metric"
                properties = {
                    title = "ECS Memory"
                    region = var.region_aws
                    metrics = [
                        ["AWS/ECS", "MemoryUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name]
                    ]
                    period = 60
                    stat = "Average"
                }
            }
        ]
    })
}