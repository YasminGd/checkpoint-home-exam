output "output_vpc_id" {
  value = aws_vpc.vpc.id
}

output "output_public_subnets_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "output_private_subnets_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}

output "alb_listener_arn" {
  value = aws_lb_listener.http_listener.arn
  description = "The ARN of the ALB listener for ECS service."
}