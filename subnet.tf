resource "aws_subnet" "private" {
  count = var.subnet_count
  vpc_id     = aws_vpc.ecs-vpc.id
  cidr_block = cidrsubnet(local.private_base_cidr, 7, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.ecs-vpc.id
  count = var.subnet_count
  cidr_block = cidrsubnet(local.public_base_cidr, 7, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${count.index}"
  }
}