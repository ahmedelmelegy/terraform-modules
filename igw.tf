resource "aws_internet_gateway" "ecs-igw" {
  vpc_id = aws_vpc.ecs-vpc.id

  tags = {
    Name = "ecs-igw"
  }
}