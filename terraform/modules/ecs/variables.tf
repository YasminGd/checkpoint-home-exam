variable "name" {
  type = string
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "task_family" {
  type        = string
  description = "The family of the ECS task definition"
}

variable "task_cpu" {
  type        = string
  description = "The number of CPU units for the task"
}

variable "task_memory" {
  type        = string
  description = "The amount of memory (in MiB) for the task"
}

variable "container_name" {
  type        = string
  description = "The name of the container"
}

variable "ecr_consumer_repository_url" {
  type        = string
  description = "The ECR repository URL for the container image"
}

variable "ecr_rest_repository_url" {
  type        = string
  description = "The ECR repository URL for the container image"
}

variable "container_port" {
  type        = number
  description = "The port on which the container listens"
}

variable "log_group" {
  type        = string
  description = "The name of the CloudWatch log group for container logs"
}

variable "region" {
  type        = string
  description = "The AWS region where resources will be created"
}

variable "target_group_arn" {
  type = string
}

variable "rest_security_group_id" {
  type = string
}

variable "consumer_security_group_id" {
  type = string
}

variable "rest_iam_role_arn" {
  type = string
}

variable "consumer_iam_role_arn" {
  type = string
}

variable "alb_listener_arn" {
  type        = string
  description = "The ARN of the ALB listener that the ECS service depends on."
}

variable "queue_url" {
  type = string
}

variable "s3_bucket_name" {
    type = string
}

variable "rest_image_tag" {
    type = string
}

variable "consumer_image_tag" {
    type = string
}