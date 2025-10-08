resource "aws_ssm_parameter" "db_username" {
    name = "/chatbot/db/username"
    type = "String"
    value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
    name = "/chatbot/db/password"
    type = "SecureString"
    value = var.db_password
}

resource "aws_ssm_parameter" "db_endpoint" {
    name = "/chatbot/db/endpoint"
    type = "String"
    value = var.db_endpoint
}

resource "aws_ssm_parameter" "db_name" {
    name = "/chatbot/db/name"
    type = "String"
    value = var.db_name
}

resource "aws_ssm_parameter" "db_port" {
    name = "/chatbot/db/port"
    type = "String"
    value = tostring(var.db_port)
}
