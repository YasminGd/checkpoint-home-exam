data "aws_iam_policy_document" "ecs_shared_tasks_policy" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [var.queue_arn]
  }

  statement {
    # ECR permission for authentication
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"] # This action requires access to all ECR resources
  }
}

data "aws_iam_policy_document" "ecs_secret_manager_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [var.secret_manager_arn]
  }

  statement {
    # ECR permissions for pulling images
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
    resources = [var.ecr_rest_repository_arn] # Reference the specific ECR ARN if available
  }
}

data "aws_iam_policy_document" "ecs_s3_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      var.s3_bucket_arn,       
      "${var.s3_bucket_arn}/*"
    ]
  }

  statement {
    # ECR permissions for pulling images
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
    resources = [var.ecr_consumer_repository_arn] # Reference the specific ECR ARN if available
  }
}

resource "aws_iam_role" "ecs_task_execution_role_rest" {
  name = "${var.name}-ecs-te-role-rest"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role_consumer" {
  name = "${var.name}-ecs-te-role-consumer"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

//permissions for secret manager
resource "aws_iam_role_policy" "ecs_task_policy_shared_rest" {
  name   = "${var.name}-ecs-task-policy-shared-rest"
  role   = aws_iam_role.ecs_task_execution_role_rest.id
  policy = data.aws_iam_policy_document.ecs_shared_tasks_policy.json
}

resource "aws_iam_role_policy" "ecs_task_policy_secret_manager_rest" {
  name   = "${var.name}-ecs-task-policy-secret-manager-rest"
  role   = aws_iam_role.ecs_task_execution_role_rest.id
  policy = data.aws_iam_policy_document.ecs_secret_manager_policy.json
}

//permissions for s3
resource "aws_iam_role_policy" "ecs_task_policy_shared_consumer" {
  name   = "${var.name}-ecs-task-policy-shared-consumer"
  role   = aws_iam_role.ecs_task_execution_role_consumer.id
  policy = data.aws_iam_policy_document.ecs_shared_tasks_policy.json
}

resource "aws_iam_role_policy" "ecs_task_policy_s3_consumer" {
  name   = "${var.name}-ecs-task-policy-s3-consumer"
  role   = aws_iam_role.ecs_task_execution_role_consumer.id
  policy = data.aws_iam_policy_document.ecs_s3_policy.json
}
