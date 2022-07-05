resource "random_id" "main" {
  byte_length = 16
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}"
  subnet_ids = var.rds_subnet_ids

  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}

resource "aws_db_instance" "main" {
  identifier                            = "${var.environment}-${var.name}"
  allocated_storage                     = var.storage
  storage_type                          = var.iops == 0 ? "gp2" : "io1"
  iops                                  = var.iops
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  engine                                = var.snapshot_identifier == null ? var.engine : null
  engine_version                        = var.ver
  instance_class                        = var.instance_class
  parameter_group_name                  = var.parameter_group
  backup_retention_period               = var.backup_retention_period
  deletion_protection                   = local.deletion_protection
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  multi_az                              = var.multi_az
  publicly_accessible                   = var.publicly_accessible
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  name                                  = var.db_name
  username                              = var.snapshot_identifier == null ? var.username : null
  password                              = var.snapshot_identifier == null ? random_id.main.b64_url : null
  vpc_security_group_ids                = var.rds_sgs
  db_subnet_group_name                  = aws_db_subnet_group.main.id
  performance_insights_enabled          = true # need to do it manually - seems to be bug in TF
  performance_insights_retention_period = 7
  # If database is about to be created from a snapshot (this correlates to the snapshot ID you'd find in the RDS console)
  snapshot_identifier = var.snapshot_identifier

  tags = {
    Env        = var.environment
    Managed_by = "Terraform"
  }
}
