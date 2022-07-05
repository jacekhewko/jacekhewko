resource "aws_sqs_queue" "main" {
  name                      = "${var.name}${local.fifo_name}"
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  redrive_policy            = var.redrive_policy
  redrive_allow_policy      = var.redrive_allow_policy
  fifo_queue                = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope = var.deduplication_scope
  fifo_throughput_limit = var.fifo_throughput_limit
  sqs_managed_sse_enabled = var.sqs_managed_sse_enabled

  tags = {
    environment = var.env
    managed_by = "terraform"
  }
}
