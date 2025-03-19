resource "aws_lb" "ecs-alb" {
  subnets = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  name = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
}

resource "aws_lb_target_group" "ecs-lb-tg" {
  name = "ecs-DevClu-notes-app-service"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs-vpc.id
  target_type = "ip"
  health_check {
    path                = "/notes"
    port                = "3000"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}