# ECS service
resource "aws_ecs_service" "main" {
  name            = "${var.name}-${var.environment}"
  cluster         = var.cluster
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.service.arn

  lifecycle {
    ignore_changes = [task_definition]
  }

  network_configuration {
    subnets         = var.ecs_subnet_ids
    security_groups = var.ecs_security_groups
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }

  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  # service_registries {
  #   registry_arn   = var.registry_arn
  #   container_name = var.name
  # }
}

# ECS task definition
resource "aws_ecs_task_definition" "service" {
  family       = "${var.name}-${var.environment}"
  network_mode = "awsvpc"
  execution_role_arn = data.aws_iam_role.ecs.arn

  container_definitions = templatefile("${path.module}/task-definitions/${var.task_def}.json", {
    name                                              = var.name
    cpu                                               = coalesce(var.cpu, 512)
    mem                                               = coalesce(var.memory, 1024)
    image                                             = var.image
    healthcheck_path                                  = var.healthcheck_path
    log_group                                         = aws_cloudwatch_log_group.main.name
    container_port                                    = var.container_port


  })

  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

# Log group
resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.name}-${var.environment}"
  retention_in_days = var.log_retention

  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}
