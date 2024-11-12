module "ecs" {
  source                      = "./modules/ecs"
  depends_on                  = [module.network, module.ecr, module.s3, module.security, module.sqs]
  private_subnets_ids         = module.network.output_private_subnets_ids
  ecr_consumer_repository_url = module.ecr.ecr_consumer_repository_url
  ecr_rest_repository_url     = module.ecr.ecr_rest_repository_url
  name                        = var.name
  task_family                 = "my-ecs-task"
  task_cpu                    = "256"
  task_memory                 = "512"
  container_name              = "rest-to-sqs-container"
  rest_image_tag              = var.rest_image_tag
  consumer_image_tag          = var.consumer_image_tag
  container_port              = var.rest_task_port
  log_group                   = "/ecs/my-service"
  region                      = var.region
  rest_security_group_id      = module.security.rest_sg_id
  consumer_security_group_id  = module.security.consumer_sg_id
  target_group_arn            = module.network.target_group_arn
  rest_iam_role_arn           = module.security.rest_iam_role_arn
  consumer_iam_role_arn       = module.security.consumer_iam_role_arn
  alb_listener_arn            = module.network.alb_listener_arn
  queue_url                   = module.sqs.queue_url
  s3_bucket_name              = module.s3.s3_bucket_name
}

module "network" {
  source                    = "./modules/network"
  name                      = var.name
  vpc_cider_block           = var.vpc_cider_block
  region                    = var.region
  number_of_public_subnets  = var.number_of_public_subnets
  number_of_private_subnets = var.number_of_private_subnets
  map_public_ip_on_launch   = var.map_public_ip_on_launch
  app_port                  = var.rest_task_port
  elb_sg_id                 = module.security.elb_sg_id
  rest_sg_id                = module.security.rest_sg_id
}

module "security" {
  depends_on                  = [module.s3, module.ecr]
  source                      = "./modules/security"
  name                        = var.name
  vpc_id                      = module.network.output_vpc_id
  app_port                    = var.rest_task_port
  queue_arn                   = module.sqs.queue_arn
  ecr_rest_repository_arn     = module.ecr.ecr_rest_repository_arn
  ecr_consumer_repository_arn = module.ecr.ecr_consumer_repository_arn
  secret_manager_arn          = var.secret_manager_arn
  s3_bucket_arn               = module.s3.s3_bucket_arn
}

module "s3" {
  source = "./modules/s3"
  name   = var.name
}

module "ecr" {
  source = "./modules/ecr"
  name   = var.name
}

module "sqs" {
  source = "./modules/sqs"
  name   = var.name
}
