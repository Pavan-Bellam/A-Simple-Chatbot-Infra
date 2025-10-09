#from vpc module

variable "vpc_id" {
  type        = string
  description = "VPC ID where ECS cluster will be deployed"
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where ECS cluster will be deployed"
}


#native
variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
  default     = "chatbot-ecs-cluster"
}

variable "ecs_instance_type" {
  type        = string
  description = "Instance type for the ECS cluster"
  default     = "t3.micro"
}
variable "desired_count" {
  type        = number
  description = "Desired number of ECS instances"
  default     = 1
}
variable "max_count" {
  type        = number
  description = "Maximum number of ECS instances"
  default     = 1
}
variable "min_count" {
  type        = number
  description = "Minimum number of ECS instances"
  default     = 1
}
variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service"
  default     = "chatbot-ecs-service"
}

variable "key_name" {
  type        = string
  description = "Name of the key pair"
  default     = "chatbot-key-pair"
}


variable "container_image" {
  type        = string
  description = "Image for the container"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container"
  default     = 8080
}

variable "task_cpu" {
  type        = number
  description = "CPU units for the task (1 vCPU = 1024)"
  default     = 512
}

variable "task_memory" {
  type        = number
  description = "Memory for the task in MB"
  default     = 1024
}

variable "force_new_deployment" {
  type        = bool
  description = "Force a new deployment on every Terraform apply"
  default     = false
}

variable "capacity_provider_target" {
  type        = number
  description = "Target capacity percentage for the capacity provider"
  default     = 100
}

variable "capacity_provider_min_step" {
  type        = number
  description = "Minimum scaling step size for capacity provider"
  default     = 1
}

variable "capacity_provider_max_step" {
  type        = number
  description = "Maximum scaling step size for capacity provider"
  default     = 1
}

#SSM Parameter Store ARNs for secrets
variable "db_username_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for database username"
}

variable "db_password_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for database password"
}

variable "db_endpoint_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for database endpoint"
}

variable "db_port_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for database port"
}

variable "db_name_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for database name"
}

variable "cognito_user_pool_id_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for Cognito User Pool ID"
}

variable "cognito_app_client_id_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for Cognito App Client ID"
}

variable "cognito_app_client_secret_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for Cognito App Client Secret"
}

variable "openai_api_key_ssm_arn" {
  type        = string
  description = "ARN of SSM parameter for OpenAI API Key"
}

#cognito region (non-sensitive, can stay as regular env var)
variable "cognito_region" {
  type        = string
  description = "AWS region for Cognito"
}
