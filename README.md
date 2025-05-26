# AWS Infrastructure Terraform Modules

This repository contains Terraform modules for deploying a comprehensive AWS infrastructure focused on containerized applications using ECS Fargate, with supporting networking, security, and container registry components.

## Overview

This project deploys a complete infrastructure for running containerized applications on AWS, including:

- VPC with public and private subnets across multiple availability zones
- ECS Fargate cluster for running containerized applications
- ECR repository for storing container images
- Application Load Balancer for routing traffic to containers
- NAT Gateway for outbound connectivity from private subnets
- Security Groups for controlling access
- IAM roles with appropriate permissions

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+)
- AWS CLI configured with appropriate credentials
- Docker (for building and pushing container images to ECR)

## Infrastructure Components

### Networking
- **VPC**: Isolated network with a default CIDR of `10.32.0.0/16`
- **Subnets**: 
  - Private subnets (`10.32.0.0/17`) for ECS tasks
  - Public subnets (`10.32.128.0/17`) for load balancers
- **Internet Gateway**: Provides internet access for public subnets
- **NAT Gateway**: Allows private resources to access the internet

### Container Services
- **ECR Repository**: For storing Docker container images
- **ECS Cluster**: Fargate-based compute platform for running containers
- **ECS Task Definition**: Defines the application container(s), including:
  - CPU and memory allocations
  - Port mappings
  - Environment variables
  - Logging configuration
- **ECS Service**: Maintains the desired number of task instances

### Load Balancing
- **Application Load Balancer**: Distributes incoming traffic to ECS services
- **Target Groups**: Routes requests to specific container instances

### Security
- **Security Groups**: Controls inbound and outbound traffic
- **IAM Roles**: Provides necessary permissions for ECS tasks

## Usage

### Initialization

```bash
terraform init
```

### Planning

```bash
terraform plan -out=tfplan
```

### Applying

```bash
terraform apply tfplan
```

### Destroying

```bash
terraform destroy
```

## Customization

### Input Variables

| Variable | Description | Default |
|----------|-------------|---------|
| vpc_region | AWS region for deploying resources | us-east-1 |
| base_cidr | VPC CIDR block | 10.32.0.0/16 |
| subnet_count | Number of availability zones/subnets to use | 3 |
| app_port | Container application port | 3000 |
| app_cpu | CPU units for the container (1024 = 1 vCPU) | 1024 |
| app_memory | Memory for the container in MB | 2048 |
| app_replica_count | Number of container instances to run | 2 |

### Example Configuration

Create a `terraform.tfvars` file to customize variables:

```hcl
vpc_region       = "us-west-2"
base_cidr        = "10.0.0.0/16"
subnet_count     = 2
app_port         = 8080
app_cpu          = 512
app_memory       = 1024
app_replica_count = 3
```

## Repository Structure

```
terraform-modules/
├── .terraform/            # Terraform plugins directory
├── modules/               # Custom Terraform modules
├── ecr.tf                 # ECR repository configuration
├── ecs-cluster.tf         # ECS cluster definition
├── ecs-roles.tf           # IAM roles for ECS
├── ecs-service.tf         # ECS service configuration
├── ecs-task.tf            # ECS task definition
├── ecs-sg.tf              # Security groups for ECS
├── lb.tf                  # Load balancer configuration
├── lb-security-group.tf   # Security groups for load balancer
├── vpc.tf                 # VPC configuration
├── subnet.tf              # Subnet definitions
├── igw.tf                 # Internet Gateway
├── nat.tf                 # NAT Gateway
├── igw-rtb.tf             # Route tables for public subnets
├── nat-rtb.tf             # Route tables for private subnets
├── variables.tf           # Input variables
├── locals.tf              # Local variables
└── providers.tf           # Provider configuration
```

## Deploying Your Application

1. Build your Docker image locally
2. Authenticate to ECR:
   ```bash
   aws ecr get-login-password --region $(terraform output -raw region) | docker login --username AWS --password-stdin $(terraform output -raw repository_url)
   ```
3. Tag your image:
   ```bash
   docker tag your-app:latest $(terraform output -raw repository_url):latest
   ```
4. Push to ECR:
   ```bash
   docker push $(terraform output -raw repository_url):latest
   ```
5. The ECS service will automatically deploy the latest image

