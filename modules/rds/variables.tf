# =============================================================================
# General Configuration
# =============================================================================

variable "create_db_instance" {
  description = "Whether to create the RDS instance"
  type        = bool
  default     = true
}

variable "db_identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
}

variable "identifier" {
  description = "The name of the RDS instance. If omitted, will use name-environment"
  type        = string
  default     = null
}

# =============================================================================
# Engine Configuration
# =============================================================================

variable "engine" {
  description = "The database engine to use (postgres, mysql, mariadb, etc.)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The engine version to use. If null, uses latest available version"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = null # Auto-detected based on engine
}

# =============================================================================
# Password Management (Secrets Manager)
# =============================================================================

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = true
}

variable "master_user_secret_kms_key_id" {
  description = "The KMS key ID to encrypt the Secrets Manager secret. If null, uses default KMS key"
  type        = string
  default     = null
}

# =============================================================================
# Storage Configuration
# =============================================================================

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling. Set to 0 to disable autoscaling"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "One of standard (magnetic), gp2, gp3, io1, or io2"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If null, uses default AWS/RDS key"
  type        = string
  default     = null
}

variable "iops" {
  description = "The amount of provisioned IOPS. Null to auto-calculate for gp3"
  type        = number
  default     = null
}

variable "storage_throughput" {
  description = "Storage throughput value for gp3 storage type (MiB/s)"
  type        = number
  default     = null
}

# =============================================================================
# Network Configuration
# =============================================================================

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. Use this OR subnet_ids, not both"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group. Use this OR db_subnet_group_name"
  type        = list(string)
  default     = []
}

variable "create_subnet_group" {
  description = "Whether to create a DB subnet group from subnet_ids"
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "The AZ for the RDS instance. Leave null for multi-AZ or AWS to choose"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}

# =============================================================================
# Backup Configuration
# =============================================================================

variable "backup_retention_period" {
  description = "The days to retain backups for (0-35). Must be > 0 for Multi-AZ"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created (UTC)"
  type        = string
  default     = "03:00-04:00" # 3-4 AM UTC
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before deletion"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier_prefix" {
  description = "Prefix for the final snapshot identifier"
  type        = string
  default     = "final"
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after deletion"
  type        = bool
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "Copy all instance tags to snapshots"
  type        = bool
  default     = true
}

# =============================================================================
# Maintenance Configuration
# =============================================================================

variable "maintenance_window" {
  description = "The window to perform maintenance in (UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00" # Sunday 4-5 AM UTC
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether modifications are applied immediately or during maintenance window"
  type        = bool
  default     = false
}

# =============================================================================
# Parameter Group Configuration
# =============================================================================

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate. If null, uses default"
  type        = string
  default     = null
}

variable "option_group_name" {
  description = "Name of the DB option group to associate"
  type        = string
  default     = null
}

# =============================================================================
# Performance Insights
# =============================================================================

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data (7 or 731)"
  type        = number
  default     = 7
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

# =============================================================================
# Enhanced Monitoring
# =============================================================================

variable "enhanced_monitoring_enabled" {
  description = "Enable enhanced monitoring. NOTE: Requires IAM role creation - not available in AWS Academy"
  type        = bool
  default     = false 
}

variable "monitoring_interval" {
  description = "The interval for enhanced monitoring metrics (0, 1, 5, 10, 15, 30, 60). 0 = disabled"
  type        = number
  default     = 0  # Changed to 0 (disabled) for AWS Academy
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role for enhanced monitoring. Required if enhanced_monitoring_enabled is true"
  type        = string
  default     = null
}

variable "create_monitoring_role" {
  description = "Create IAM role for enhanced monitoring. Set to false for AWS Academy"
  type        = bool
  default     = false  
}

# =============================================================================
# CloudWatch Logs
# =============================================================================

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch (depends on engine)"
  type        = list(string)
  default     = ["postgresql"] # For PostgreSQL: postgresql, upgrade
}

# =============================================================================
# Security Configuration
# =============================================================================

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = true
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether IAM database authentication is enabled"
  type        = bool
  default     = false
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

# =============================================================================
# Blue/Green Deployment
# =============================================================================

variable "enable_blue_green_deployment" {
  description = "Enable low-downtime updates using Blue/Green deployment"
  type        = bool
  default     = false
}

# =============================================================================
# Restore from Snapshot or Point in Time
# =============================================================================

variable "snapshot_identifier" {
  description = "Specifies whether or not to create from a snapshot"
  type        = string
  default     = null
}

variable "restore_to_point_in_time" {
  description = "Configuration for restoring to point in time"
  type = object({
    restore_time                             = optional(string)
    source_db_instance_identifier            = optional(string)
    source_db_instance_automated_backups_arn = optional(string)
    source_dbi_resource_id                   = optional(string)
    use_latest_restorable_time               = optional(bool)
  })
  default = null
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "db_instance_tags" {
  description = "Additional tags for the DB instance"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_tags" {
  description = "Additional tags for the DB subnet group"
  type        = map(string)
  default     = {}
}

# =============================================================================
# Timeouts
# =============================================================================

variable "timeouts" {
  description = "Timeouts for database operations"
  type = object({
    create = optional(string, "40m")
    update = optional(string, "80m")
    delete = optional(string, "60m")
  })
  default = {}
}
