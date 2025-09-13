# VPC Module terragrunt.hcl
# This file defines the structure and validation rules for the VPC module

include {
  path = find_in_parent_folders()
}

terraform {
  # Force Terraform to keep trying to acquire a lock for up to 20 minutes if someone else has the lock
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }
}

# Input validation rules
locals {
  # Validate subnet count
  vpc_config = local.vpc_config
  
  valid_subnet_count = var.subnet_count > 0 && var.subnet_count <= 6 ? true : tobool(
    "Error: subnet_count must be between 1 and 6"
  )

  # Ensure CIDR block is valid format
  valid_cidr = can(cidrnetmask(var.base_cidr)) ? true : tobool(
    "Error: base_cidr must be a valid CIDR block"
  )
  
  # Common tags that should be applied to all resources
  common_tags = {
    Module     = "vpc"
    ManagedBy  = "terragrunt"
    Owner      = "infrastructure-team"
  }
}

# Variable descriptions used for documentation
inputs = {
  description = {
    environment = "The deployment environment (dev, staging, prod)"
    base_cidr = "Base CIDR block for the VPC (e.g. 10.0.0.0/16)"
    subnet_count = "Number of subnets to create per type (public/private)"
    public_subnet_bits = "Number of subnet bits for public subnets CIDR calculation"
    private_subnet_bits = "Number of subnet bits for private subnets CIDR calculation"
  }
}

