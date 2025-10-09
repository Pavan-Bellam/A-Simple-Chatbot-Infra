resource "aws_ecs_task_definition" "this" {
  family                   = "${var.cluster_name}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "chatbot-container"
      image     = var.container_image
      essential = true

      port_mappings = [
        {
          container_port = var.container_port
          host_port      = var.container_port
          protocol       = "tcp"
        }
      ]

      environment = [
        {
          name  = "COGNITO_REGION"
          value = var.cognito_region
        }
      ]

      secrets = [
        {
          name      = "DB_USERNAME"
          valueFrom = var.db_username_ssm_arn
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_ssm_arn
        },
        {
          name      = "DB_ENDPOINT"
          valueFrom = var.db_endpoint_ssm_arn
        },
        {
          name      = "DB_PORT"
          valueFrom = var.db_port_ssm_arn
        },
        {
          name      = "DB_NAME"
          valueFrom = var.db_name_ssm_arn
        },
        {
          name      = "COGNITO_USER_POOL_ID"
          valueFrom = var.cognito_user_pool_id_ssm_arn
        },
        {
          name      = "COGNITO_APP_CLIENT_ID"
          valueFrom = var.cognito_app_client_id_ssm_arn
        },
        {
          name      = "COGNITO_APP_CLIENT_SECRET"
          valueFrom = var.cognito_app_client_secret_ssm_arn
        },
        {
          name      = "OPENAI_API_KEY"
          valueFrom = var.openai_api_key_ssm_arn
        }
      ]

      health_check = {
        command      = ["CMD-SHELL", "nc -z localhost ${var.container_port} || exit 1"]
        interval     = 30
        timeout      = 10
        retries      = 3
        start_period = 60
      }
    }
  ])
}