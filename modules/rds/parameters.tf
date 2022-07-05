resource "aws_ssm_parameter" "rds-password" {
  name        = "/${var.environment}/rds/${var.db_name}/password"
  description = "Database password"
  type        = "SecureString"
  value       = aws_db_instance.main.password
  overwrite   = true

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "aws_ssm_parameter" "rds-username" {
  name        = "/${var.environment}/rds/${var.db_name}/username"
  description = "Database username"
  type        = "SecureString"
  value       = aws_db_instance.main.username
  overwrite   = true

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "aws_ssm_parameter" "rds-address" {
  name        = "/${var.environment}/rds/${var.db_name}/address"
  description = "Database address"
  type        = "SecureString"
  value       = aws_db_instance.main.address
  overwrite   = true

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
