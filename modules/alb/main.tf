# Load balancer
resource "aws_lb" "main" {
  name               = "${var.name}-${var.environment}-${local.lb_internal}"
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = var.lb_sgs
  subnets            = var.lb_subnets

  enable_deletion_protection = var.lb_deletion_protection

  access_logs {
    bucket  = aws_s3_bucket.logs.bucket
    enabled = true
  }

  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

data "aws_elb_service_account" "this" {}

resource "aws_s3_bucket" "logs" {
  bucket        = "${var.name}-${var.environment}-lb-logs"
  acl           = "private"
  policy        = data.aws_iam_policy_document.logs.json
  force_destroy = true
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this.arn]
    }

    resources = [
      "arn:aws:s3:::${var.name}-${var.environment}-lb-logs/*",
    ]
  }
}
