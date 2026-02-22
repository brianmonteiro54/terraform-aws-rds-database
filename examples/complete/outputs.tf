output "db_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.db_instance_id
}

output "db_instance_endpoint" {
  description = "Connection endpoint (host:port)"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_address" {
  description = "Hostname of the RDS instance"
  value       = module.rds.db_instance_address
}

output "db_instance_port" {
  description = "Database port"
  value       = module.rds.db_instance_port
}

output "db_instance_name" {
  description = "Database name"
  value       = module.rds.db_instance_name
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the master password"
  value       = module.rds.master_user_secret_arn
  sensitive   = true
}

output "get_password_command" {
  description = "AWS CLI command to retrieve the master password"
  value       = module.rds.get_password_command
}

output "security_group_id" {
  description = "Security group ID attached to the RDS instance"
  value       = module.rds.security_group_id
}

output "db_subnet_group_id" {
  description = "DB subnet group name"
  value       = module.rds.db_subnet_group_id
}

output "connection_string_psql" {
  description = "Example psql connection command"
  value       = module.rds.connection_string_psql
}
