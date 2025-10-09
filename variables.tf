variable "region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

#vpc
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnet deployment"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway for private subnet internet access"
  type        = bool
  default     = false
}


#rds
variable "db_name" {
  type        = string
  default     = "chatbotDB"
  description = "Name of the database"
}

variable "db_username" {
  type        = string
  default     = "chatbot_user"
  description = "Username for the database"
  sensitive   = true
}

variable "db_password" {
  type        = string
  default     = "chatbot_password"
  description = "Password for the database"
  sensitive   = true
}

variable "db_instance_type" {
  type        = string
  default     = "db.t3.micro"
  description = "Instance type for the database"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Whether to deploy the database in multiple availability zones for high availability(Failover)"
}

variable "db_storage_size" {
  type        = number
  default     = 10
  description = "Storage size for the database"
}

variable "db_engine_version" {
  type        = string
  default     = "15.8"
  description = "Engine version for the database"
}

variable "db_engine" {
  type        = string
  default     = "postgres"
  description = "Database engine"
}

#ecs
variable "cluster_name" {
  type        = string
  default     = "chatbot-ecs-cluster"
  description = "Name of the ECS cluster"
}

variable "container_image" {
  type        = string
  description = "Docker image for the container (e.g., account.dkr.ecr.region.amazonaws.com/repo:tag)"
}

variable "container_port" {
  type        = number
  default     = 8080
  description = "Port exposed by the container application"
}

variable "task_cpu" {
  type        = number
  default     = 512
  description = "CPU units for the ECS task (1 vCPU = 1024)"
}

variable "task_memory" {
  type        = number
  default     = 1024
  description = "Memory for the ECS task in MB"
}

variable "ecs_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type for ECS cluster"
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "Desired number of ECS tasks to run"
}

variable "min_count" {
  type        = number
  default     = 1
  description = "Minimum number of EC2 instances in autoscaling group"
}

variable "max_count" {
  type        = number
  default     = 1
  description = "Maximum number of EC2 instances in autoscaling group"
}

variable "key_name" {
  type        = string
  default     = "chatbot-key-pair"
  description = "Name of the EC2 key pair for SSH access"
}

variable "force_new_deployment" {
  type        = bool
  default     = false
  description = "Force a new ECS deployment on every Terraform apply"
}

variable "capacity_provider_target" {
  type        = number
  default     = 100
  description = "Target capacity percentage for the ECS capacity provider"
}

variable "capacity_provider_min_step" {
  type        = number
  default     = 1
  description = "Minimum scaling step size for capacity provider"
}

variable "capacity_provider_max_step" {
  type        = number
  default     = 1
  description = "Maximum scaling step size for capacity provider"
}