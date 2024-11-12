resource "aws_eip" "nat" {
  count = var.number_of_public_subnets
  tags = {
    Name = "${var.name}_eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.number_of_public_subnets
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.name}_nat_gw_${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.gw]
}
