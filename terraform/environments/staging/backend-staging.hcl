bucket = ecomm-app-state-bucket
key = "staging/terraform.tfstate"
encrypt = true
dynamodb_table = "terraform-state-locks"
region = "us-east-1"