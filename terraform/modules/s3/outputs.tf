output "s3_bucket_name" {
    value = "yasmin-checkpoint-s3"
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.bucket.arn
}