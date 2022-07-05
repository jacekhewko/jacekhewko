# Providing S3 bucket for object file storage.
# Placing it inside `ecs` module since it's very likely that we would need
# one storage bucket per each ECS service. If not - it can be freely moved.
# You can always abandon creating S3 via the variable on count argument.

resource "aws_s3_bucket" "storage" {
  count         = local.storage_bucket
  bucket_prefix = "beis-${var.environment}-${var.name}"
  acl           = "private"
  force_destroy = local.s3_force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}
