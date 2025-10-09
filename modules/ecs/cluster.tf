resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.cluster_name}-capacity-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_autoscaling_group.arn
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = var.capacity_provider_target
      minimum_scaling_step_size = var.capacity_provider_min_step
      maximum_scaling_step_size = var.capacity_provider_max_step
    }
  }
  tags = { Name = "chatbot-ecs-capacity-provider" }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 1
    base              = 0
  }

}