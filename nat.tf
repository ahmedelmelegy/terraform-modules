resource "aws_eip" "nat-gateway-eip" {
  tags = {
    Name = "nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "ecs-natgateway" {
  connectivity_type = "public"
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "ecs-natgateway"
  }
}