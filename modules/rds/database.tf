# =============================================================================
# RDS Database Instance
# =============================================================================

resource "aws_db_instance" "this" {
  count = var.create_db_instance ? 1 : 0

  # Identifier
  identifier = local.db_identifier

  # Engine Configuration
  engine         = var.engine
  engine_version = local.engine_version
  instance_class = var.instance_class
  db_name        = var.db_name
  port           = local.port

  # Credentials
  username                    = var.username
  manage_master_user_password = var.manage_master_user_password
  master_user_secret_kms_key_id = var.manage_master_user_password ? var.master_user_secret_kms_key_id : null

  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = local.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id
  iops                  = local.calculated_iops
  storage_throughput    = var.storage_throughput

  # Network
  db_subnet_group_name   = local.subnet_group_name
  vpc_security_group_ids = local.vpc_security_group_ids
  publicly_accessible    = var.publicly_accessible
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az

  # Backup
  backup_retention_period = local.backup_retention_period
  backup_window           = local.backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = local.final_snapshot_identifier
  delete_automated_backups  = var.delete_automated_backups
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot

  # Maintenance
  maintenance_window         = local.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately          = var.apply_immediately

  # Parameter and Option Groups
  parameter_group_name = local.parameter_group_name
  option_group_name    = var.option_group_name

  # Performance Insights
  performance_insights_enabled          = local.performance_insights_enabled
  performance_insights_retention_period = local.performance_insights_retention
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id

  # Enhanced Monitoring
  monitoring_interval = local.monitoring_interval
  monitoring_role_arn = local.monitoring_role_arn

  # CloudWatch Logs
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Security
  deletion_protection                = var.deletion_protection
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  ca_cert_identifier                 = var.ca_cert_identifier

  # Blue/Green Deployment
  dynamic "blue_green_update" {
    for_each = local.blue_green_enabled && var.enable_blue_green_deployment ? [1] : []
    content {
      enabled = true
    }
  }

  # Restore from Snapshot
  snapshot_identifier = var.snapshot_identifier

  # Restore to Point in Time
  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []
    content {
      restore_time                             = try(restore_to_point_in_time.value.restore_time, null)
      source_db_instance_identifier            = try(restore_to_point_in_time.value.source_db_instance_identifier, null)
      source_db_instance_automated_backups_arn = try(restore_to_point_in_time.value.source_db_instance_automated_backups_arn, null)
      source_dbi_resource_id                   = try(restore_to_point_in_time.value.source_dbi_resource_id, null)
      use_latest_restorable_time               = try(restore_to_point_in_time.value.use_latest_restorable_time, null)
    }
  }

  # Tags
  tags = merge(
    local.common_tags,
    var.db_instance_tags,
    {
      Name = local.db_identifier
    }
  )

  # Timeouts
  timeouts {
    create = try(var.timeouts.create, "40m")
    update = try(var.timeouts.update, "80m")
    delete = try(var.timeouts.delete, "60m")
  }

  # Prevent issues with monitoring role - only depend if creating role
depends_on = [
    aws_iam_role_policy_attachment.enhanced_monitoring
  ]
  lifecycle {
    ignore_changes = [
      # Ignore changes to snapshot_identifier after creation
      snapshot_identifier,
      # Ignore engine_version_actual changes if auto_minor_version_upgrade is enabled
      engine_version,
    ]
  }
}
