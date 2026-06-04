resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket = "ecomm-app-state-bucket"
}


resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
    bucket = aws_s3_bucket.terraform_state_bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}


resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform_state_locks"
    billing_mode = "PAY_PER_REQUEST"

    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}