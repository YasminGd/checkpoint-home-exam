data "aws_availability_zones" "available" {}

#public subnets
resource "aws_subnet" "public_subnets" {
  count             = var.number_of_public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.name}_public_subnet_${count.index + 1}"
  }
}


#private subnets
resource "aws_subnet" "private_subnets" {
  count                   = var.number_of_private_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${count.index + 10}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}_private_subnet_${count.index + 1}"
  }
}