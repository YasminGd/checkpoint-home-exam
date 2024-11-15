provider aws {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "yasmin-terraform-state"
     
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "yasmin-tf-state-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}