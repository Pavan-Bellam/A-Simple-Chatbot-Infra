resource "aws_security_group" "ecs_security_group" {
  name        = "chatbot-ecs-security-group"
  description = "Security group for the ECS cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "chatbot-ecs-security-group" }

}
