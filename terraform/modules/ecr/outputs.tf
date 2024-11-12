output "ecr_rest_repository_url" {
  value       = aws_ecr_repository.rest_ecr.repository_url
  description = "The url of the rest ECR repository"
}

output "ecr_consumer_repository_url" {
  value       = aws_ecr_repository.consumer_ecr.repository_url
  description = "The url of the consumer ECR repository"
}

output "ecr_rest_repository_arn" {
  value       = aws_ecr_repository.rest_ecr.arn
  description = "The arn of the rest ECR repository"
}

output "ecr_consumer_repository_arn" {
  value       = aws_ecr_repository.consumer_ecr.arn
  description = "The arn of the consumer ECR repository"
}
