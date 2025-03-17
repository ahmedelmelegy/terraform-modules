resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.ecs-vpc.id
  cidr_block = "10.32.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private subnet 1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.ecs-vpc.id
  cidr_block = "10.32.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private subnet 2"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.ecs-vpc.id
  cidr_block = "10.32.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public subnet 1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.ecs-vpc.id
  cidr_block = "10.32.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public subnet 2"
  }
}

resource "aws_eip" "nat-gateway-eip" {
  tags = {
    Name = "nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "ecs-natgateway" {
  connectivity_type = "public"
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id = aws_subnet.subnet-1.id
  tags = {
    Name = "ecs-natgateway"
  }
}

resource "aws_route_table" "nat-rtb" {
  vpc_id = aws_vpc.ecs-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs-natgateway.id
  }

  tags = {
    Name = "nat-rtb"
  }
}

resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.nat-rtb.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.nat-rtb.id
}

resource "aws_internet_gateway" "ecs-igw" {
  vpc_id = aws_vpc.ecs-vpc.id

  tags = {
    Name = "ecs-igw"
  }
}

resource "aws_route_table" "igw-rtb" {
  vpc_id = aws_vpc.ecs-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-igw.id
  }

  tags = {
    Name = "igw-rtb"
  }
}

resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.igw-rtb.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.igw-rtb.id
}