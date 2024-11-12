resource "aws_security_group" "rest_sg" {
  name        = "yasmin_rest_task_sg"
  description = "Security group for ECS service allowing access only from ELB"
  vpc_id      = var.vpc_id

  # Allow inbound traffic only from the ELB's security group
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
    description     = "Allow access from ELB only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "yasmin_elb_sg"
  description = "Security group for ELB allowing HTTP and HTTPS access"
  vpc_id      = var.vpc_id

  # Allow inbound HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from anywhere"
  }

  # Allow inbound HTTPS traffic from anywhere
  #   ingress {
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #     description = "Allow HTTPS traffic from anywhere"
  #   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "consumer_sg" {
  name        = "yasmin_consumer_task_sg"
  description = "Security group for ECS consumer task to access AWS services within the VPC"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
