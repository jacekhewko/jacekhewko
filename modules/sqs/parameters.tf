resource "aws_ssm_parameter" "sqs-url" {
  name        = "/${var.env}/sqs/${var.name}/url"
  description = "SQS URL"
  type        = "SecureString"
  value       = aws_sqs_queue.main.url

  tags = {
    environment = var.env
    managed_by  = "terraform"
  }
}
