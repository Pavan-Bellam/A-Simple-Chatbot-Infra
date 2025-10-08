#rds credentials
variable "db_username" {
    type = string
    description = "Username for the database"
}

variable "db_password" {
    type = string
    description = "Password for the database"
}

variable "db_endpoint" {
    type = string
    description = "Endpoint for the database"
}

variable "db_name" {
    type = string
    description = "Name of the database"
}

variable "db_port" {
    type = number
    description = "Port for the database"
}
