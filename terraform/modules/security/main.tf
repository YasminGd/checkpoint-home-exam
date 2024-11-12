# iam_role.tf
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}_ecs_task_execution_role"

  # Define the trusted entity for ECS tasks
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Optional: Attach a policy with necessary permissions for the ECS task
# resource "aws_iam_policy" "ecs_task_policy" {
#   name        = "ecs_task_policy"
#   description = "Policy to allow ECS task to access required services"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Action   = [
#           "s3:GetObject",
#           "s3:ListBucket",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = aws_iam_policy.ecs_task_policy.arn
# }
