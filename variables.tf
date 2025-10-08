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
  type    = string
  default = "postgres"
}