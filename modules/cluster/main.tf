resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_launch_template" "main" {
  name_prefix            = "${var.env}"
  image_id               = local.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups
  user_data = base64encode(templatefile("${path.module}/user_data/cis.bash", {
    cluster_name = var.cluster_name
  }))

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.vol_size
      volume_type           = "gp2"
      delete_on_termination = "true"
      encrypted             = "true"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${var.env}"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_size
  health_check_grace_period = 0
  vpc_zone_identifier       = var.asg_subnets
  termination_policies      = ["OldestLaunchTemplate"]

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Env"
    value               = var.env
    propagate_at_launch = true
  }

  tag {
    key                 = "Managed_by"
    value               = "Terraform"
    propagate_at_launch = true
  }
}
