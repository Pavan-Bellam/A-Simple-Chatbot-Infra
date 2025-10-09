module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = var.enable_nat_gateway
}

module "rds" {
  source = "./modules/rds"

  #variables
  #from vpc module
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  #from variables
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
  db_engine_version = var.db_engine_version
  db_instance_type  = var.db_instance_type
  db_storage_size   = var.db_storage_size
  db_engine         = var.db_engine
  multi_az          = var.multi_az
}

module "ssm" {
  source = "./modules/ssm"

  #variables
  #from rds module
  db_username = module.rds.db_username
  db_password = module.rds.db_password
  db_endpoint = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_name     = module.rds.db_name
}

module "ecs" {
  source = "./modules/ecs"

  #from vpc module
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  #container configuration
  container_image = var.container_image
  container_port  = var.container_port
  task_cpu        = var.task_cpu
  task_memory     = var.task_memory

  #cluster configuration
  cluster_name      = var.cluster_name
  ecs_instance_type = var.ecs_instance_type
  desired_count     = var.desired_count
  min_count         = var.min_count
  max_count         = var.max_count
  key_name          = var.key_name

  #deployment configuration
  force_new_deployment        = var.force_new_deployment
  capacity_provider_target    = var.capacity_provider_target
  capacity_provider_min_step  = var.capacity_provider_min_step
  capacity_provider_max_step  = var.capacity_provider_max_step


  #SSM parameter ARNs for secrets (from SSM module)
  db_username_ssm_arn              = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/db/username"
  db_password_ssm_arn              = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/db/password"
  db_endpoint_ssm_arn              = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/db/endpoint"
  db_port_ssm_arn                  = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/db/port"
  db_name_ssm_arn                  = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/db/name"
  cognito_user_pool_id_ssm_arn     = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/cognito/user_pool_id"
  cognito_app_client_id_ssm_arn    = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/cognito/app_client_id"
  cognito_app_client_secret_ssm_arn = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/cognito/app_client_secret"
  openai_api_key_ssm_arn           = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/chatbot/openai/api_key"

  #cognito region (non-sensitive)
  cognito_region = var.region
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}