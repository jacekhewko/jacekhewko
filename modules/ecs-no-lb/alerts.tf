# Alerting
resource "aws_cloudwatch_metric_alarm" "high-cpu" {
  alarm_name          = "ecs-${var.name}-${var.environment}_high_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_cpu
  dimensions = {
    ClusterName = var.cluster
    ServiceName = aws_ecs_service.main.name
  }
  alarm_actions = [var.alarm_action, aws_appautoscaling_policy.up.arn]
}

resource "aws_cloudwatch_metric_alarm" "low-cpu" {
  alarm_name          = "ecs-${var.name}-${var.environment}_low_cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = 0
  dimensions = {
    ClusterName = var.cluster
    ServiceName = aws_ecs_service.main.name
  }
  alarm_actions = [var.alarm_action, aws_appautoscaling_policy.down.arn]
}

resource "aws_cloudwatch_metric_alarm" "high_mem" {
  alarm_name          = "ecs-${var.name}-${var.environment}_high_mem"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_mem
  dimensions = {
    ClusterName = var.cluster
    ServiceName = aws_ecs_service.main.name
  }
  alarm_actions = [var.alarm_action]
}
