variable "name" {
  description = "Security group name"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for EC2"
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "ingress_from_port" {
  description = "Ingress from port"
  type        = number
  default     = 22
}

variable "ingress_to_port" {
  description = "Ingress to port"
  type        = number
  default     = 22
}

variable "ingress_protocol" {
  description = "Protocol for ingress"
  type        = string
  default     = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed for ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags for the security group"
  type        = map(string)
  default     = {}
}
