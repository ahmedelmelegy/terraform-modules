locals {
  # Calculate base CIDR blocks for public and private subnets
  # Assuming first half of VPC CIDR for public, second half for private
  public_base_cidr  = cidrsubnet(var.base_cidr, 1, 0)  # First half of VPC CIDR
  private_base_cidr = cidrsubnet(var.base_cidr, 1, 1)  # Second half of VPC CIDR
  
  # Tags that should be applied to all resources
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
    Project     = "ecs-project"
  }
}

