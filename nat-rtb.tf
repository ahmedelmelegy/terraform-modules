resource "aws_route_table" "nat-rtb" {
  vpc_id = aws_vpc.ecs-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs-natgateway.id
  }

  tags = {
    Name = "nat-rtb"
  }
}

resource "aws_route_table_association" "private_subnet_assoc" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.nat-rtb.id
}