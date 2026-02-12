# =============================================================================
# Enhanced Monitoring IAM Role
# =============================================================================
# NOTE: Enhanced Monitoring requires IAM role creation
# AWS Academy does NOT allow IAM role creation
# Therefore, enhanced monitoring is DISABLED by default in this module
#
# If you have a regular AWS account and want to enable it:
# 1. Set enhanced_monitoring_enabled = true
# 2. Set create_monitoring_role = true
# 3. OR provide your own monitoring_role_arn
# =============================================================================

# Create IAM role for RDS enhanced monitoring
# ONLY if NOT AWS Academy and create_monitoring_role is true
resource "aws_iam_role" "enhanced_monitoring" {
  count = var.create_db_instance && var.create_monitoring_role && var.enhanced_monitoring_enabled ? 1 : 0

  name        = "${local.db_identifier}-rds-monitoring-role"
  description = "IAM role for RDS enhanced monitoring of ${local.db_identifier}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.${data.aws_partition.current.dns_suffix}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.db_identifier}-rds-monitoring-role"
    }
  )
}

# Attach the AWS managed policy for RDS enhanced monitoring
# ONLY if role was created
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.create_db_instance && var.create_monitoring_role && var.enhanced_monitoring_enabled ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
