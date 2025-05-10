resource "aws_ecs_cluster" "ecs-project" {
  name = "ecs-project"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/app-container"
  retention_in_days = 30
}