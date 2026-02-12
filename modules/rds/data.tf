# =============================================================================
# Data Sources
# =============================================================================

# Current AWS partition
data "aws_partition" "current" {}

# Get latest PostgreSQL engine version if not specified
data "aws_rds_engine_version" "postgresql" {
  count = var.engine_version == null ? 1 : 0

  engine             = var.engine
  preferred_versions = ["16.4", "16.3", "16.2", "16.1", "15.8", "15.7"]
}
