output "db_endpoint" {
    value = aws_db_instance.this.endpoint
}

output "rds_instance_id" {
    value = aws_db_instance.this.id
}

output "db_username" {
    value     = aws_db_instance.this.username
    sensitive = true
}

output "db_password" {
    value     = aws_db_instance.this.password
    sensitive = true
}

output "db_port" {
    value = aws_db_instance.this.port
}

output "db_name" {
    value = aws_db_instance.this.db_name
}