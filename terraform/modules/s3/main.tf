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