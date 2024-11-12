#public vpc with gateway and routetable
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cider_block

  tags = {
    Name = "${var.name}_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}_gw"
  }
}