# A-Simple-Chatbot-Infra

Terraform infrastructure setup for a simple chatbot application with AWS remote state management.

## Overview

This repository contains Terraform configurations to manage infrastructure for a chatbot application. It includes a bootstrap setup for creating an S3 bucket to store Terraform state files with versioning enabled.

## Prerequisites

- Terraform (compatible with AWS provider ~> 6.15.0)
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create S3 buckets and manage resources

## Project Structure

```
A-Simple-Chatbot-Infra/
├── bootstrap/              # Bootstrap configuration for S3 state bucket
│   ├── providers.tf       # AWS provider configuration
│   ├── s3.tf             # S3 bucket and versioning resources
│   └── output.tf         # Outputs bucket name
├── providers.tf          # Main provider configuration with S3 backend
├── backend.dev.hcl       # Backend configuration for dev environment (gitignored)
└── backend.example.hcl   # Example backend configuration template
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

### Step 3: Initialize Main Configuration

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

## Usage

After completing the setup:

1. Make changes to your Terraform configurations
2. Plan your changes: `terraform plan`
3. Apply changes: `terraform apply`
4. Destroy resources (if needed): `terraform destroy`

## Environment Management

To manage multiple environments (dev, staging, prod):

1. Create separate backend configuration files (e.g., `backend.staging.hcl`, `backend.prod.hcl`)
2. Use different `key` values in each backend config to separate state files
3. Initialize with the appropriate backend: `terraform init -backend-config=backend.<env>.hcl`

## Notes

- The `backend.dev.hcl` file is gitignored to prevent committing environment-specific credentials
- State files contain sensitive information and should never be committed to version control
- Always run `terraform plan` before `terraform apply` to review changes