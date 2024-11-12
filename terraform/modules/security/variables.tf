variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "app_port" {
  type = number
}

variable "queue_arn" {
  type = string
}

variable "ecr_rest_repository_arn" {
    type = string
}

variable "ecr_consumer_repository_arn" {
  type = string
}

variable "secret_manager_arn" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}