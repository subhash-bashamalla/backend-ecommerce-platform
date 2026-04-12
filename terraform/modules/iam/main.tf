resource "aws_iam_role" "ecs_task_role" {
    name = "${var.env_name}-ecs-task-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ecs-tasks.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}


resource "aws_iam_role_policy" "ecs_s3_access" {
    role = var.task_role_name

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:PutObject",
                    "s3:GetObject"
                ]
                Effect = "Allow"
                Resource = "arn:aws:s3:::${var.bucket_name}/*"
            }
        ]
    })
}


resource "aws_iam_role" "ecs_execution_role" {
    name = "${var.env_name}-ecs-exec-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ecs-tasks.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}


resource "aws_iam_role_policy_attachment" "ecs_exec_policy" {
    role = aws_iam_role.ecs_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


