# =============================================================================
# Local Values
# =============================================================================

locals {
  # Database identifier
  db_identifier = var.db_identifier

  # Engine version - use data source if not specified
  engine_version = coalesce(
    var.engine_version,
    try(data.aws_rds_engine_version.postgresql[0].version, "16.4")
  )

  # Parameter group name
  parameter_group_name = var.parameter_group_name != null ? var.parameter_group_name : "default.${var.engine}${split(".", local.engine_version)[0]}"

  # Backup configuration
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  # Storage configuration
  storage_type = var.iops != null ? (var.iops >= 64000 ? "io2" : "io1") : var.storage_type

  # Auto-calculate IOPS for gp3 if not specified
  calculated_iops = (
    var.storage_type == "gp3" &&
    var.iops == null &&
    var.allocated_storage >= 400
  ) ? min(max(3000, var.allocated_storage * 3), 16000) : var.iops

  # Subnet group name
  subnet_group_name = var.create_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name

  # Security group IDs - use created security group or provided IDs
  vpc_security_group_ids = var.create_security_group ? concat(
    [aws_security_group.this[0].id],
    var.vpc_security_group_ids
  ) : var.vpc_security_group_ids

  # Performance Insights
  performance_insights_enabled   = var.performance_insights_enabled
  performance_insights_retention = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  # Monitoring
  monitoring_interval = var.enhanced_monitoring_enabled ? var.monitoring_interval : 0
  monitoring_role_arn = var.enhanced_monitoring_enabled ? (
    var.monitoring_role_arn != null ? var.monitoring_role_arn : (
      var.create_monitoring_role ? try(aws_iam_role.enhanced_monitoring[0].arn, null) : null
    )
  ) : null

  # Port - auto-detect based on engine
  port = coalesce(
    var.port,
    var.engine == "postgres" ? 5432 : (
      var.engine == "mysql" ? 3306 : (
        var.engine == "mariadb" ? 3306 : (
          var.engine == "oracle-se2" ? 1521 : (
            var.engine == "sqlserver-ex" ? 1433 : null
          )
        )
      )
    )
  )

  # Tags
  common_tags = merge(
    var.tags,
    {
      Name        = local.db_identifier
      Environment = var.environment
      ManagedBy   = "Terraform"
      Engine      = var.engine
    }
  )

  # Final snapshot identifier
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.db_identifier}-final-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Blue/Green deployment
  blue_green_enabled = var.enable_blue_green_deployment && contains(["postgres", "mysql", "mariadb"], var.engine)
}
