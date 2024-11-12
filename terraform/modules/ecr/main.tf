resource "aws_ecr_repository" "rest_ecr" {
  name                 = "${var.name}-rest-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "consumer_ecr" {
  name                 = "${var.name}-consumer-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}