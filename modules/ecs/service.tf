resource "aws_ecs_service" "this" {
    name = "${var.cluster_name}-service"
    cluster = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.this.arn
    desired_count = var.desired_count
    network_configuration {
        subnets = var.private_subnet_ids
        security_groups = [aws_security_group.ecs_security_group.id]
        assign_public_ip = false
    }
    capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
        weight = 1
    }

    # Deployment configuration
    deployment_maximum_percent         = 200
    deployment_minimum_healthy_percent = 100

    enable_execute_command = true
    propagate_tags = "TASK_DEFINITION"
    force_new_deployment = var.force_new_deployment
    scheduling_strategy = "REPLICA"
    tags = {Name = "chatbot-ecs-service"}
}