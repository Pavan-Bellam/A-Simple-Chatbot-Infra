resource "aws_launch_template" "ecs_launch_template" {

  name_prefix   = "${var.cluster_name}-launch-template"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.ecs_instance_type
  key_name      = var.key_name


  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ecs_security_group.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  user_data = base64encode(<<-EOF
                    #!/bin/bash
                    set -e

                    # Configure ECS cluster
                    echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config

                    # Enable and start ECS agent
                    systemctl enable --now ecs

                    # Verify ECS agent is running
                    systemctl is-active --quiet ecs || exit 1

                    echo "ECS instance successfully configured and joined cluster ${var.cluster_name}"
                    EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 50
      volume_type = "gp2"
      encrypted   = true
    }
  }

  tags = { Name = "chatbot-ecs-launch-template" }
}



resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                      = "${var.cluster_name}-autoscaling-group"
  min_size                  = var.min_count
  max_size                  = var.max_count
  desired_capacity          = var.desired_count
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "ECS"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "chatbot-ecs-autoscaling-group"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity]
  }

}
