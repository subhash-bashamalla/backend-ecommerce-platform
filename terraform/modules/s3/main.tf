resource "aws_s3_bucket" "bucket_main" {
    bucket = "${var.env_name}-app-image-bucket"
}

resource "aws_s3_bucket_public_access_block" "pub_acc_block" {
    bucket = aws_s3_bucket.bucket_main.id

    block_public_policy = true
    block_public_acls = true

    ignore_public_acls = true
    restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "bucket_main_versioning" {
    bucket = aws_s3_bucket.bucket_main.id

    versioning_configuration {
        status = "Enabled"
    }
}


resource "aws_s3_bucket" "alb_logs" {
    bucket = "${var.env_name}-logs-alb"
}


resource "aws_s3_bucket_policy" "alb_logs_policy" {
    bucket = aws_s3_bucket.alb_logs.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow"
            Principal = {
                Service = "logdelivery.elasticloadbalancing.amazonaws.com"
            },
            Action = "s3:PutObject",
            Resource = "${aws_s3_bucket.alb_logs.arn}/*"
            }
        ]
    })
}