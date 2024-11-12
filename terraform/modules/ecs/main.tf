resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-cluster"
}

resource "aws_ecs_task_definition" "rest_task" {
  family                   = "rest-to-sqs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.rest_iam_role_arn
  task_role_arn            = var.rest_iam_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${var.ecr_rest_repository_url}:${var.rest_image_tag}"
      essential = true
      "environment" : [
        { "name" : "SECRET_NAME", "value" : "yasmin_checkpoint_home_exam_token" },
        { "name" : "REGION_NAME", "value" : var.region },
        { "name" : "SQS_QUEUE_URL", "value" : var.queue_url }
      ]
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      # logConfiguration = {
      #   logDriver = "awslogs"
      #   options = {
      #     "awslogs-group"         = var.log_group
      #     "awslogs-region"        = var.region
      #     "awslogs-stream-prefix" = var.container_name
      #   }
      # }
    }
  ])
}

resource "aws_ecs_service" "rest_service" {
  # name            = var.service_name
  name            = "rest-to-sqs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.rest_task.arn
  launch_type     = "FARGATE"

  desired_count = 1

  network_configuration {
    subnets          = var.private_subnets_ids
    security_groups  = [var.rest_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  depends_on = [var.alb_listener_arn]
}


resource "aws_ecs_task_definition" "consumer_task" {
  family                   = "sqs-to-s3-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.consumer_iam_role_arn
  task_role_arn            = var.consumer_iam_role_arn

  container_definitions = jsonencode([
    {
      name      = "sqs-to-s3-container"
      image     = "${var.ecr_consumer_repository_url}:${var.consumer_image_tag}"
      essential = true
      environment = [
        { name = "SQS_QUEUE_URL", value = var.queue_url },
        { name = "S3_BUCKET_NAME", value = var.s3_bucket_name },
        { name = "S3_FOLDER", value = "messages" }
      ]
    }
  ])
}

resource "aws_ecs_service" "consumer_service" {
  # name            = var.service_name
  name            = "sqs-to-s3-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.consumer_task.arn
  launch_type     = "FARGATE"

  desired_count = 1

  network_configuration {
    subnets          = var.private_subnets_ids
    security_groups  = [var.consumer_security_group_id]
    assign_public_ip = false
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}
