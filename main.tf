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