resource "aws_vpc" "ecs-vpc" {
  cidr_block = "10.32.0.0/16"
  tags = {
    Name = "ecs-vpc"
  }
  tags_all = {
    Name = "ecs-vpc"
  }
}

resource "aws_security_group" "ecs-sg" {
  name        = "ecs-sg"
  description = "allow all test"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  // outbound internet access
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs-sg" {
  name        = "efs-sg"
  description = "efs security group"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
      from_port = 2049
      to_port = 2049
      protocol = "tcp"
      security_groups = ["sg-0d3be17332a2a1001"]
  }

  // outbound internet access
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "lb security group"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  // outbound internet access
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}