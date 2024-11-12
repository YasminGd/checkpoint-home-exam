variable "name" {
  type = string
}

variable "vpc_cider_block" {
  type = string
}

variable "region" {
  type = string
}

variable "number_of_public_subnets" {
  type = number
}

variable "number_of_private_subnets" {
  type = number
}

variable "map_public_ip_on_launch" {
  type = bool
}

variable "app_port" {
  type = number
}

variable "elb_sg_id" {
  type = string
}
variable "rest_sg_id" {
  type = string
}