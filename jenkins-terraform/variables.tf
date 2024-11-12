variable "region" {
  description = "The AWS region where the resources will be deployed"
  type        = string
}

variable "name" {
  description = "Name tag for the project"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the resources"
  type        = map(string)
}
