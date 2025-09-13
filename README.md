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

## Configuration

### S3 Backend Setup (Required)

Before running Terraform, you need to create an S3 bucket for storing the state file:

1. **Create the S3 bucket manually:**
   ```bash
   aws s3 mb s3://your-terraform-state-bucket --region us-east-1
   ```

2. **Update the backend configuration in `providers.tf`:**
   ```hcl
   backend "s3" {
     bucket        = "your-actual-bucket-name"  # Replace with your bucket name
     key           = "terraform-modules/terraform.tfstate"
     region        = "us-east-1"  # Replace with your preferred region
     encrypt       = true
     use_lockfile  = true
   }
   ```

### Input Variables

| Variable | Description | Type | Default | Notes |
|----------|-------------|------|---------|-------|
| `vpc_region` | AWS region for deploying resources | string | "us-east-1" | Choose your preferred AWS region |
| `base_cidr` | VPC CIDR block | string | "10.32.0.0/16" | Must be a valid CIDR block |
| `subnet_count` | Number of availability zones/subnets to use | number | 3 | Should match number of AZs in region |
| `app_port` | Container application port | number | 3000 | Port your application listens on |
| `app_cpu` | CPU units for the container (1024 = 1 vCPU) | number | 1024 | AWS Fargate CPU allocation |
| `app_memory` | Memory for the container in MB | number | 2048 | AWS Fargate memory allocation |
| `app_replica_count` | Number of container instances to run | number | 2 | Desired number of running tasks |
| `ecr_name` | Name of the ECR repository | string | "app_acr" | ECR repository for your container images |
| `container_image` | The container image to use for the application | string | null | **Required** - Must be specified (e.g., 'nginx:latest' or ECR URI) |

### Example Configurations

#### Development Environment
Create a `dev.tfvars` file:

```hcl
vpc_region        = "us-west-2"
base_cidr         = "10.0.0.0/16"
subnet_count      = 2
app_port          = 8080
app_cpu           = 512
app_memory        = 1024
app_replica_count = 1
ecr_name          = "my-app-dev"
container_image   = "nginx:latest"  # For testing
```

#### Production Environment
Create a `prod.tfvars` file:

```hcl
vpc_region        = "us-east-1"
base_cidr         = "10.1.0.0/16"
subnet_count      = 3
app_port          = 80
app_cpu           = 2048
app_memory        = 4096
app_replica_count = 3
ecr_name          = "my-app-prod"
container_image   = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.0.0"
```

#### Using with ECR
If you want to use the ECR repository created by this module:

```hcl
# After first deployment, get the ECR repository URL
container_image = "${aws_ecr_repository.apps_ecr.repository_url}:latest"
```

### Deploy with Custom Variables

```bash
# Using a tfvars file
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Using command line variables
terraform apply -var="vpc_region=us-west-2" -var="container_image=nginx:latest"

# Using environment variables
export TF_VAR_vpc_region="us-west-2"
export TF_VAR_container_image="nginx:latest"
terraform apply
```

## Repository Structure

```
terraform-modules/
├── .terraform/            # Terraform plugins directory
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
