resource "aws_ecr_repository" "main" {
  name = var.repository_name

  image_scanning_configuration {
    scan_on_push = var.image_scan
  }
}

