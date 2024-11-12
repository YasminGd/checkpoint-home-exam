output "rest_sg_id" {
  description = "The ID of the rest application security group"
  value       = aws_security_group.rest_sg.id
}

output "elb_sg_id" {
  description = "The ID of the ELB security group"
  value       = aws_security_group.elb_sg.id
}

output "consumer_sg_id" {
  description = "The ID of the consumer application security group"
  value       = aws_security_group.consumer_sg.id
}

output "rest_iam_role_arn" {
  value = aws_iam_role.ecs_task_execution_role_rest.arn
}

output "consumer_iam_role_arn" {
  value = aws_iam_role.ecs_task_execution_role_consumer.arn
}

