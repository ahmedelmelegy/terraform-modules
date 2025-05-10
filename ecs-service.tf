resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.ecs-project.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.app_replica_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [for subnet in aws_subnet.private : subnet.id]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-lb-tg.arn
    container_name   = "app-container"
    container_port   = var.app_port
  }

  depends_on = [
    aws_lb.ecs-alb,
    aws_iam_role_policy_attachment.ecs_execution_role_policy
  ]
}