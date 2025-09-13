variable "vpc_region" {
  default = "us-east-1"
}

variable "base_cidr" {
  default = "10.32.0.0/16"
}

variable "subnet_count" {
  type    = number
  default = 3
}

variable "app_port" {
  type    = number
  default = 3000
}

variable "app_cpu" {
  type    = number
  default = 1024
}

variable "app_memory" {
  type    = number
  default = 2048
}

variable "app_replica_count" {
  type    = number
  default = 2
}

variable "ecr_name" {
  type        = string
  default     = "app_acr"
}

variable "container_image" {
  description = "The container image to use for the application (e.g., 'my-repo/my-app:latest')"
  type        = string
  default     = null # This will force users to specify an image
}
