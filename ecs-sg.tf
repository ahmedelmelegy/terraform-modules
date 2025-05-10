resource "aws_security_group" "ecs-sg" {
  name        = "ecs-sg"
  description = "allow all test"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
      from_port = var.app_port
      to_port = var.app_port
      protocol = "tcp"
      security_groups = [aws_security_group.lb-sg.id]  # ALB SG
      description = "Allow traffic from ALB"
  }

  // outbound internet access
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}