resource "aws_lb" "ecs-alb" {
  subnets = [for subnet in aws_subnet.public : subnet.id]
  name = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
}

resource "aws_lb_target_group" "ecs-lb-tg" {
  name = "ecs-app-service"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs-vpc.id
  target_type = "ip"
  health_check {
    path                = "/notes"
    port                = var.app_port
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-lb-tg.arn
  }
}