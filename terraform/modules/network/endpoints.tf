resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id           = aws_vpc.vpc.id
  service_name     = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = aws_route_table.private_rt[*].id  

  tags = {
    Name = "${var.name}_s3_endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.ecr.api"  
  vpc_endpoint_type = "Interface"
  subnet_ids   = aws_subnet.private_subnets[*].id 
  security_group_ids = [var.rest_sg_id]  

  tags = {
    Name = "${var.name}_ecr_api_endpoint"
  }
}

resource "aws_vpc_endpoint" "sqs_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.sqs"  
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnets[*].id  
  security_group_ids = [var.rest_sg_id]  

  tags = {
    Name = "${var.name}_sqs_endpoint"
  }
}