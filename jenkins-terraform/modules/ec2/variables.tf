variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for the instance"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "EC2 instance ami"
  type        = string
}

variable "name" {
  description = "name prefix for the instance"
  type        = string
}

variable "admin_role_name" {
  type = string
}
