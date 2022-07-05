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

# Alerting of LB
locals {
  alarm_actions             = var.alarm_action
  ok_actions                = var.alarm_action
  insufficient_data_actions = var.alarm_action

  thresholds = {
    target_3xx_count     = max(var.target_3xx_count_threshold, 0)
    target_4xx_count     = max(var.target_4xx_count_threshold, 0)
    target_5xx_count     = max(var.target_5xx_count_threshold, 0)
    elb_5xx_count        = max(var.elb_5xx_count_threshold, 0)
    target_response_time = max(var.target_response_time_threshold, 0)
  }

  target_3xx_alarm_enabled           = var.target_3xx_count_threshold > 0
  target_4xx_alarm_enabled           = var.target_4xx_count_threshold > 0
  target_5xx_alarm_enabled           = var.target_5xx_count_threshold > 0
  elb_5xx_alarm_enabled              = var.elb_5xx_count_threshold > 0
  target_response_time_alarm_enabled = var.target_response_time_threshold > 0

  target_group_dimensions_map = {
    "TargetGroup"  = aws_lb_target_group.main.arn
    "LoadBalancer" = var.load_balancer_arn
  }

  load_balancer_dimensions_map = {
    "LoadBalancer" = var.load_balancer_arn
  }
}

resource "aws_cloudwatch_metric_alarm" "httpcode_target_3xx_count" {
  count                     = local.target_3xx_alarm_enabled ? 1 : 0
  alarm_name                = "tg-${var.name}-${var.environment}_3xx_errors"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "HTTPCode_Target_3XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = 300
  statistic                 = "Sum"
  threshold                 = local.thresholds["target_3xx_count"]
  alarm_actions             = [local.alarm_actions]
  ok_actions                = [local.ok_actions]
  insufficient_data_actions = [local.insufficient_data_actions]
  dimensions                = local.target_group_dimensions_map
}

resource "aws_cloudwatch_metric_alarm" "httpcode_target_4xx_count" {
  count                     = local.target_4xx_alarm_enabled ? 1 : 0
  alarm_name                = "tg-${var.name}-${var.environment}_4xx_errors"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "HTTPCode_Target_4XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = 300
  statistic                 = "Sum"
  threshold                 = local.thresholds["target_4xx_count"]
  alarm_actions             = [local.alarm_actions]
  ok_actions                = [local.ok_actions]
  insufficient_data_actions = [local.insufficient_data_actions]
  dimensions                = local.target_group_dimensions_map
}

resource "aws_cloudwatch_metric_alarm" "httpcode_target_5xx_count" {
  count                     = local.target_5xx_alarm_enabled ? 1 : 0
  alarm_name                = "tg-${var.name}-${var.environment}_5xx_errors"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "HTTPCode_Target_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = 300
  statistic                 = "Sum"
  threshold                 = local.thresholds["target_5xx_count"]
  alarm_actions             = [local.alarm_actions]
  ok_actions                = [local.ok_actions]
  insufficient_data_actions = [local.insufficient_data_actions]
  dimensions                = local.target_group_dimensions_map
}

resource "aws_cloudwatch_metric_alarm" "httpcode_elb_5xx_count" {
  count                     = local.elb_5xx_alarm_enabled ? 1 : 0
  alarm_name                = "lb-${var.name}-${var.environment}_3xx_errors"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "HTTPCode_ELB_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = 300
  statistic                 = "Sum"
  threshold                 = local.thresholds["elb_5xx_count"]
  alarm_actions             = [local.alarm_actions]
  ok_actions                = [local.ok_actions]
  insufficient_data_actions = [local.insufficient_data_actions]
  dimensions                = local.load_balancer_dimensions_map
}

resource "aws_cloudwatch_metric_alarm" "target_response_time_average" {
  count                     = local.target_response_time_alarm_enabled ? 1 : 0
  alarm_name                = "tg-${var.name}-${var.environment}_response_time"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "TargetResponseTime"
  namespace                 = "AWS/ApplicationELB"
  period                    = 300
  statistic                 = "Average"
  threshold                 = local.thresholds["target_response_time"]
  alarm_actions             = [local.alarm_actions]
  ok_actions                = [local.ok_actions]
  insufficient_data_actions = [local.insufficient_data_actions]
  dimensions                = local.target_group_dimensions_map
}
