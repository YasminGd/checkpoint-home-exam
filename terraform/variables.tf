variable "region" {
  description = "aws region"
  type        = string
}

variable "tags" {
  description = "The tags for the project"
  type        = map(string)
}

variable "vpc_cider_block" {
  description = "default cider block"
  type        = string
}

variable "name" {
  description = "env name"
  type        = string
}

variable "number_of_public_subnets" {
  description = "The number of public subnets to be created"
  type        = number
}

variable "number_of_private_subnets" {
  description = "The number of private subnets to be created"
  type        = number
}

variable "map_public_ip_on_launch" {
  description = "Whether to map a public IP on launch"
  type        = bool
}

variable "rest_task_port" {
  type = number
}

variable "secret_manager_arn" {
  type = string
}

variable "rest_image_tag" {
  type = string
}

variable "consumer_image_tag" {
  type = string
}
