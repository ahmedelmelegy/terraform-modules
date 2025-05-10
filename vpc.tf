data "aws_availability_zones" "available" {}

resource "aws_vpc" "ecs-vpc" {
  cidr_block = var.base_cidr
  tags = {
    Name = "ecs-vpc"
  }
  tags_all = {
    Name = "ecs-vpc"
  }
}