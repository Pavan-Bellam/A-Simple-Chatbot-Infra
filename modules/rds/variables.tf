#from vpc module
variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  type        = list(string)
}



variable "db_name" {
    type = string
    description = "Name of the database"
}

variable "db_username" {
    type = string
    default = "chatbot-user"
    description = "Username for the database"
    sensitive = true
}

variable "db_password" {
    type = string
    default = "chatbot-password"
    description = "Password for the database"
    sensitive = true
}

variable "db_instance_type" {
    type = string
    default = "db.t3.micro"
    description = "Instance type for the database"
}

variable "multi_az" {
    type = bool
    default = false
    description = "Whether to deploy the database in multiple availability zones for high availability(Failover)"
}

variable "db_storage_size" {
    type = number
    default = 10
    description = "Storage size for the database"
}

variable "db_engine_version" {
    type = string
    default = "15.8"
    description = "Engine version for the database"
}

variable "db_engine" {
    type = string
    default = "postgres"
    description = "Engine for the database"
}