#security group

resource "aws_security_group" "rds_security_group" {
    name = "chatbot-main-rds-security-group"
    description = "Security group for the RDS database"
    vpc_id = var.vpc_id
    tags = {Name = "chatbot-rds-security-group"}
}
#security group rules will be created when alb is created

#subnet groups
resource "aws_db_subnet_group" "this" {
    name = "chatbot-rds-subnet-group"
    subnet_ids = var.private_subnet_ids
    tags = {Name = "chatbot-rds-subnet-group"}
}

resource "aws_db_instance" "this" {
    identifier = "chatbot-rds-instance"
    engine = var.db_engine
    engine_version = var.db_engine_version
    instance_class = var.db_instance_type
    allocated_storage = var.db_storage_size
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.this.name
    vpc_security_group_ids = [aws_security_group.rds_security_group.id]
    publicly_accessible = false
    multi_az = var.multi_az
    storage_encrypted = true
    skip_final_snapshot = true
    deletion_protection = false
    backup_retention_period = 1
    tags = {Name = "chatbot-rds-instance"}
}

