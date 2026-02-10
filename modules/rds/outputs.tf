# =============================================================================
# Database Instance Outputs
# =============================================================================

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = try(aws_db_instance.this[0].id, null)
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.this[0].arn, null)
}

output "db_instance_identifier" {
  description = "The identifier of the RDS instance"
  value       = try(aws_db_instance.this[0].identifier, null)
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_db_instance.this[0].resource_id, null)
}

# =============================================================================
# Connection Information
# =============================================================================

output "db_instance_endpoint" {
  description = "The connection endpoint (address:port)"
  value       = try(aws_db_instance.this[0].endpoint, null)
}

output "db_instance_address" {
  description = "The hostname of the RDS instance"
  value       = try(aws_db_instance.this[0].address, null)
}

output "db_instance_port" {
  description = "The database port"
  value       = try(aws_db_instance.this[0].port, null)
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (for Route 53)"
  value       = try(aws_db_instance.this[0].hosted_zone_id, null)
}

# =============================================================================
# Database Information
# =============================================================================

output "db_instance_name" {
  description = "The database name"
  value       = try(aws_db_instance.this[0].db_name, null)
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = try(aws_db_instance.this[0].username, null)
  sensitive   = true
}

output "db_instance_engine" {
  description = "The database engine"
  value       = try(aws_db_instance.this[0].engine, null)
}

output "db_instance_engine_version" {
  description = "The running version of the database"
  value       = try(aws_db_instance.this[0].engine_version_actual, null)
}

# =============================================================================
# Secrets Manager (Master Password)
# =============================================================================

output "master_user_secret_arn" {
  description = "The ARN of the secret containing the master password"
  value       = try(aws_db_instance.this[0].master_user_secret[0].secret_arn, null)
  sensitive   = true
}

output "master_user_secret_kms_key_id" {
  description = "The KMS key ID used to encrypt the master password secret"
  value       = try(aws_db_instance.this[0].master_user_secret[0].kms_key_id, null)
}

output "master_user_secret_status" {
  description = "The status of the secret"
  value       = try(aws_db_instance.this[0].master_user_secret[0].secret_status, null)
}

# =============================================================================
# Networking
# =============================================================================

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_db_subnet_group.this[0].id, null)
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = try(aws_db_subnet_group.this[0].arn, null)
}

output "db_instance_availability_zone" {
  description = "The availability zone of the instance"
  value       = try(aws_db_instance.this[0].availability_zone, null)
}

# =============================================================================
# Storage
# =============================================================================

output "db_instance_allocated_storage" {
  description = "The amount of allocated storage"
  value       = try(aws_db_instance.this[0].allocated_storage, null)
}

output "db_instance_storage_encrypted" {
  description = "Whether the DB instance is encrypted"
  value       = try(aws_db_instance.this[0].storage_encrypted, null)
}

# =============================================================================
# Backup & Maintenance
# =============================================================================

output "db_instance_backup_retention_period" {
  description = "The backup retention period"
  value       = try(aws_db_instance.this[0].backup_retention_period, null)
}

output "db_instance_backup_window" {
  description = "The backup window"
  value       = try(aws_db_instance.this[0].backup_window, null)
}

output "db_instance_maintenance_window" {
  description = "The instance maintenance window"
  value       = try(aws_db_instance.this[0].maintenance_window, null)
}

output "db_instance_latest_restorable_time" {
  description = "The latest time to which a database can be restored with point-in-time restore"
  value       = try(aws_db_instance.this[0].latest_restorable_time, null)
}

# =============================================================================
# Monitoring
# =============================================================================

output "db_instance_status" {
  description = "The RDS instance status"
  value       = try(aws_db_instance.this[0].status, null)
}

output "enhanced_monitoring_role_arn" {
  description = "The ARN of the enhanced monitoring IAM role"
  value       = try(aws_iam_role.enhanced_monitoring[0].arn, null)
}

# =============================================================================
# Connection String Examples
# =============================================================================

output "connection_string_psql" {
  description = "Example psql connection string (password from Secrets Manager)"
  value       = var.create_db_instance && var.engine == "postgres" ? "psql -h ${try(aws_db_instance.this[0].address, "")} -p ${try(aws_db_instance.this[0].port, "")} -U ${try(aws_db_instance.this[0].username, "")} -d ${try(aws_db_instance.this[0].db_name, "postgres")}" : null
}

output "connection_string_jdbc" {
  description = "Example JDBC connection string (password from Secrets Manager)"
  value       = var.create_db_instance && var.engine == "postgres" ? "jdbc:postgresql://${try(aws_db_instance.this[0].endpoint, "")}/${try(aws_db_instance.this[0].db_name, "postgres")}" : null
}

# =============================================================================
# Secrets Manager Commands
# =============================================================================

output "get_password_command" {
  description = "AWS CLI command to retrieve the master password from Secrets Manager"
  value       = var.create_db_instance && var.manage_master_user_password ? "aws secretsmanager get-secret-value --secret-id ${try(aws_db_instance.this[0].master_user_secret[0].secret_arn, "")} --query SecretString --output text | jq -r .password" : null
}
