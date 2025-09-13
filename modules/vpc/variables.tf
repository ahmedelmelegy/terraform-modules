variable "environment" {
  description = "The deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "base_cidr" {
  description = "Base CIDR block for the VPC"
  type        = string
  default     = "10.32.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets to create (per type: public and private)"
  type        = number
  default     = 2
}

variable "public_subnet_bits" {
  description = "Number of subnet bits for public subnets CIDR calculation"
  type        = number
  default     = 7
}

variable "private_subnet_bits" {
  description = "Number of subnet bits for private subnets CIDR calculation"
  type        = number
  default     = 7
}

