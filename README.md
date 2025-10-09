# A-Simple-Chatbot-Infra

Terraform infrastructure setup for a simple chatbot application with AWS remote state management.

## Overview

This repository contains Terraform configurations to manage infrastructure for a chatbot application, including:
- **VPC Module**: Configurable VPC with public/private subnets, Internet Gateway, NAT Gateway (optional), and route tables
- **RDS Module**: PostgreSQL database instance with security groups and subnet groups
- **SSM Module**: AWS Systems Manager Parameter Store for securely storing database credentials
- **ECS Module**: ECS cluster with EC2 launch type, autoscaling, capacity providers, and containerized application deployment
- **Bootstrap Setup**: S3 bucket for Terraform remote state management with versioning

**Note**: All default values in `variables.tf` are configured to incur **low to no cost**. You should customize these values based on your production requirements.

## Prerequisites

### Required Tools
- Terraform (compatible with AWS provider ~> 6.15.0)
- AWS CLI configured with appropriate credentials

### Required AWS IAM Permissions

Before running this Terraform project, ensure your AWS IAM user/role has the following permissions:

#### S3 (for Terraform state backend)
- `s3:CreateBucket`, `s3:DeleteBucket`
- `s3:GetBucketVersioning`, `s3:PutBucketVersioning`
- `s3:GetBucketTagging`, `s3:PutBucketTagging`
- `s3:ListBucket`, `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject`

#### EC2/VPC
- `ec2:CreateVpc`, `ec2:DeleteVpc`, `ec2:DescribeVpcs`, `ec2:ModifyVpcAttribute`
- `ec2:CreateSubnet`, `ec2:DeleteSubnet`, `ec2:DescribeSubnets`, `ec2:ModifySubnetAttribute`
- `ec2:CreateInternetGateway`, `ec2:DeleteInternetGateway`, `ec2:AttachInternetGateway`, `ec2:DetachInternetGateway`, `ec2:DescribeInternetGateways`
- `ec2:CreateRouteTable`, `ec2:DeleteRouteTable`, `ec2:DescribeRouteTables`
- `ec2:CreateRoute`, `ec2:DeleteRoute`, `ec2:AssociateRouteTable`, `ec2:DisassociateRouteTable`
- `ec2:AllocateAddress`, `ec2:ReleaseAddress`, `ec2:DescribeAddresses`
- `ec2:CreateNatGateway`, `ec2:DeleteNatGateway`, `ec2:DescribeNatGateways` (if enabling NAT Gateway)
- `ec2:CreateSecurityGroup`, `ec2:DeleteSecurityGroup`, `ec2:DescribeSecurityGroups`
- `ec2:AuthorizeSecurityGroupIngress`, `ec2:AuthorizeSecurityGroupEgress`, `ec2:RevokeSecurityGroupIngress`, `ec2:RevokeSecurityGroupEgress`
- `ec2:CreateTags`, `ec2:DeleteTags`, `ec2:DescribeTags`

#### RDS
- `rds:CreateDBInstance`, `rds:DeleteDBInstance`, `rds:DescribeDBInstances`, `rds:ModifyDBInstance`
- `rds:CreateDBSubnetGroup`, `rds:DeleteDBSubnetGroup`, `rds:DescribeDBSubnetGroups`
- `rds:AddTagsToResource`, `rds:RemoveTagsFromResource`, `rds:ListTagsForResource`

#### SSM Parameter Store
- `ssm:PutParameter`, `ssm:GetParameter`, `ssm:GetParameters`, `ssm:DeleteParameter`
- `ssm:DescribeParameters`, `ssm:AddTagsToResource`, `ssm:RemoveTagsFromResource`, `ssm:ListTagsForResource`

#### ECS (Elastic Container Service)
- `ecs:CreateCluster`, `ecs:DeleteCluster`, `ecs:DescribeClusters`
- `ecs:CreateService`, `ecs:DeleteService`, `ecs:DescribeServices`, `ecs:UpdateService`
- `ecs:RegisterTaskDefinition`, `ecs:DeregisterTaskDefinition`, `ecs:DescribeTaskDefinition`
- `ecs:CreateCapacityProvider`, `ecs:DeleteCapacityProvider`, `ecs:DescribeCapacityProviders`
- `ecs:PutClusterCapacityProviders`

#### AutoScaling (for ECS capacity provider)
- `autoscaling:CreateAutoScalingGroup`, `autoscaling:DeleteAutoScalingGroup`, `autoscaling:DescribeAutoScalingGroups`, `autoscaling:UpdateAutoScalingGroup`
- `autoscaling:CreateLaunchConfiguration`, `autoscaling:DeleteLaunchConfiguration`
- `autoscaling:DescribeLaunchConfigurations`
- `ec2:CreateLaunchTemplate`, `ec2:DeleteLaunchTemplate`, `ec2:DescribeLaunchTemplates`
- `ec2:RunInstances`, `ec2:TerminateInstances`, `ec2:DescribeInstances`

#### IAM (for ECS roles)
- `iam:CreateRole`, `iam:DeleteRole`, `iam:GetRole`, `iam:ListRoles`
- `iam:CreatePolicy`, `iam:DeletePolicy`, `iam:GetPolicy`
- `iam:AttachRolePolicy`, `iam:DetachRolePolicy`, `iam:ListAttachedRolePolicies`
- `iam:CreateInstanceProfile`, `iam:DeleteInstanceProfile`, `iam:AddRoleToInstanceProfile`, `iam:RemoveRoleFromInstanceProfile`
- `iam:PassRole`

**Tip**: You can create a custom IAM policy with these permissions or use AWS managed policies like `PowerUserAccess` (not recommended for production).

## Project Structure

```
A-Simple-Chatbot-Infra/
├── bootstrap/              # Bootstrap configuration for S3 state bucket
│   ├── providers.tf       # AWS provider configuration
│   ├── s3.tf             # S3 bucket and versioning resources
│   └── output.tf         # Outputs bucket name
├── modules/
│   ├── vpc/               # VPC module with subnets, IGW, NAT, route tables
│   │   ├── vpc.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/               # RDS PostgreSQL module with security groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ssm/               # SSM Parameter Store module for secrets
│   │   ├── main.tf
│   │   └── variables.tf
│   └── ecs/               # ECS cluster module with EC2 instances
│       ├── cluster.tf
│       ├── service.tf
│       ├── task_definition.tf
│       ├── asg.tf
│       ├── iam.tf
│       ├── sg.tf
│       ├── variables.tf
│       └── outputs.tf
├── main.tf                # Root module configuration
├── variables.tf           # Input variables (customize these!)
├── outputs.tf             # Output values
├── providers.tf           # Provider configuration with S3 backend
├── backend.dev.hcl        # Backend configuration for dev environment (gitignored)
└── backend.example.hcl    # Example backend configuration template
```

## Setup Instructions

### Step 1: Bootstrap S3 State Bucket

First, create the S3 bucket that will store your Terraform state files:

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

This creates:
- S3 bucket: `a-simple-chatbot-terraform-state-bucket`
- Versioning enabled on the bucket

### Step 2: Configure Backend

Copy the example backend configuration and customize it for your environment:

```bash
cp backend.example.hcl backend.dev.hcl
```

Edit `backend.dev.hcl` with your environment-specific settings:
- `bucket`: The S3 bucket name (created in Step 1)
- `key`: Path within the bucket for the state file
- `region`: AWS region (default: us-east-1)
- `encrypt`: Enable encryption for state files
- `bucket_lock_enabled`: Enable state locking

### Step 3: Configure Variables

**Important**: Before deploying, review and customize the values in `variables.tf` according to your requirements:

**VPC Configuration**:
- `vpc_cidr`: CIDR block for your VPC (default: `10.0.0.0/16`)
- `public_subnet_cidrs`: CIDR blocks for public subnets (default: `["10.0.1.0/24", "10.0.2.0/24"]`)
- `private_subnet_cidrs`: CIDR blocks for private subnets (default: `["10.0.3.0/24", "10.0.4.0/24"]`)
- `availability_zones`: AZs for subnet deployment (default: `["us-east-1a", "us-east-1b"]`)
- `enable_nat_gateway`: Enable NAT Gateway for private subnets (default: `false` to minimize cost)

**RDS Configuration**:
- `db_name`: Database name (default: `chatbotDB`)
- `db_username`: Database username (default: `chatbot_user`) - **Change this!**
- `db_password`: Database password (default: `chatbot_password`) - **Change this immediately!**
- `db_engine`: Database engine (default: `postgres`)
- `db_engine_version`: PostgreSQL version (default: `15.8`)
- `db_instance_type`: Instance type (default: `db.t3.micro` - free tier eligible)
- `db_storage_size`: Allocated storage in GB (default: `10`)
- `multi_az`: Enable Multi-AZ deployment (default: `false` to minimize cost)

**ECS Configuration**:
- `cluster_name`: Name of the ECS cluster (default: `chatbot-ecs-cluster`)
- `container_image`: Docker image URI - **Required, no default!** (e.g., `123456789012.dkr.ecr.us-east-1.amazonaws.com/chatbot:latest`)
- `container_port`: Port exposed by container (default: `8080`)
- `task_cpu`: CPU units for task (default: `512` = 0.5 vCPU)
- `task_memory`: Memory for task in MB (default: `1024` = 1GB)
- `ecs_instance_type`: EC2 instance type (default: `t3.micro` - free tier eligible)
- `desired_count`: Number of tasks to run (default: `1`)
- `min_count`/`max_count`: ASG instance limits (default: `1`/`1` to minimize cost)
- `key_name`: EC2 key pair name (default: `chatbot-key-pair`) - **Must exist in AWS!**
- `force_new_deployment`: Force deployment on every apply (default: `false`)

**Security Warning**:
- The default credentials are placeholders. **You must change `db_username` and `db_password` before deploying to any environment!**
- **You must create an EC2 key pair** in AWS console or CLI before deploying ECS (or change the `key_name` variable)
- **You must provide a `container_image`** - this is required with no default value

**Important Notes**:
- SSM Parameter Store ARNs for Cognito and OpenAI are currently placeholders in `main.tf` - update these after creating Cognito module
- ECS will fetch secrets from SSM Parameter Store at container startup (no secrets in environment variables!)

### Step 4: Initialize Main Configuration

Initialize the main Terraform configuration with the backend:

```bash
terraform init -backend-config=backend.dev.hcl
```

## Backend Configuration

### Example Backend Configuration

```hcl
bucket              = "a-simple-chatbot-terraform-state-bucket"
key                 = "env/terraform.tfstate"
region              = "us-east-1"
encrypt             = true
bucket_lock_enabled = true
```

## AWS Provider

The project uses AWS provider version `~> 6.15.0` and targets the `us-east-1` region by default.

## Infrastructure Resources

This Terraform configuration will create:

**VPC Module**:
- 1 VPC with DNS support and hostnames enabled
- 2 Public subnets (configurable)
- 2 Private subnets (configurable)
- 1 Internet Gateway
- 1 Public route table with internet route
- 1 Private route table
- 1 NAT Gateway with Elastic IP (optional, disabled by default for cost savings)

**RDS Module**:
- 1 PostgreSQL RDS instance (db.t3.micro, 10GB storage)
- 1 DB subnet group spanning private subnets
- 1 Security group for RDS (rules to be added when ALB is created)
- Storage encryption enabled
- Automated backups (1-day retention)

**SSM Module**:
- 5 SSM parameters for database credentials and connection info:
  - `/chatbot/db/username`
  - `/chatbot/db/password` (SecureString)
  - `/chatbot/db/endpoint`
  - `/chatbot/db/name`
  - `/chatbot/db/port`

**ECS Module**:
- 1 ECS cluster with EC2 launch type
- 1 ECS service with rolling deployment configuration
- 1 Task definition with container specifications
- 1 Capacity provider with managed scaling
- 1 Autoscaling group (1 EC2 instance by default)
- 1 Launch template with ECS-optimized AMI
- 1 Security group for ECS tasks (ingress rules to be added when ALB is created)
- 3 IAM roles:
  - EC2 instance profile role (for ECS agent)
  - Task execution role (for pulling images and fetching secrets from SSM)
  - Task role (for application permissions)
- Secrets management: Container fetches credentials from SSM Parameter Store at startup

**Cost Optimization Features**:
- NAT Gateway disabled by default (enable only if needed)
- Minimal instance counts (1 task, 1 EC2 instance)
- Free tier eligible instance types (t3.micro, db.t3.micro)
- No Multi-AZ deployment by default

## Usage

After completing the setup steps above:

1. Review your variable customizations in `variables.tf`
2. Plan your changes:
   ```bash
   terraform plan -var-file=terraform.tfvars  # if using tfvars
   # or simply
   terraform plan
   ```
3. Review the plan output carefully
4. Apply changes:
   ```bash
   terraform apply
   ```
5. Destroy resources when no longer needed:
   ```bash
   terraform destroy
   ```

**Note**: Since you've initialized with a backend configuration (`terraform init -backend-config=backend.dev.hcl`), Terraform will automatically use the remote state backend. You don't need to specify the backend config for `plan`, `apply`, or `destroy` commands.

**Cost Optimization**: By default, NAT Gateway is disabled and RDS uses minimal settings. Enable Multi-AZ and NAT Gateway only when needed for production workloads.

## Environment Management

To manage multiple environments (dev, staging, prod):

1. Create separate backend configuration files (e.g., `backend.staging.hcl`, `backend.prod.hcl`)
2. Use different `key` values in each backend config to separate state files
3. Initialize with the appropriate backend: `terraform init -backend-config=backend.<env>.hcl`

## Notes

- The `backend.dev.hcl` file is gitignored to prevent committing environment-specific credentials
- State files contain sensitive information and should never be committed to version control
- Always run `terraform plan` before `terraform apply` to review changes