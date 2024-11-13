
tags = {
  Objective  = "checkpoint_home_exam"
  Email      = "yasmin.gudha@develeap.com"
  Expiration = "20241130"
}

name                      = "yasmin-checkpoint-home-exam"
vpc_cider_block           = "10.0.0.0/16"
region                    = "us-east-1"
number_of_public_subnets  = 2
number_of_private_subnets = 2
map_public_ip_on_launch   = true
rest_task_port            = 5000
secret_manager_arn        = "arn:aws:secretsmanager:us-east-1:006262944085:secret:yasmin_checkpoint_home_exam_token-VEhv7I"
rest_image_tag            = "1.0.20"
consumer_image_tag        = "1.0.11"
