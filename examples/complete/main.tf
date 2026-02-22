# =============================================================================
# Example: Complete RDS PostgreSQL Instance
#
# This example provisions a production-ready RDS PostgreSQL instance with:
#   - Password managed automatically via AWS Secrets Manager
#   - Storage encryption enabled (AWS-managed key)
#   - Multi-AZ disabled for cost savings in dev (enable for prod)
#   - Performance Insights enabled (7-day free retention)
#   - Automated backups with 7-day retention
#   - Deletion protection enabled
#   - IAM database authentication enabled
#   - Security group allowing PostgreSQL only from within VPC
#
# Usage:
#   terraform init
#   terraform plan \
#     -var="vpc_id=vpc-xxxx" \
#     -var='subnet_ids=["subnet-aaa","subnet-bbb"]'
#   terraform apply \
#     -var="vpc_id=vpc-xxxx" \
#     -var='subnet_ids=["subnet-aaa","subnet-bbb"]'
# =============================================================================

module "rds" {
  source = "../../modules/rds"

  # ---------------------------------------------------
  # Required
  # ---------------------------------------------------
  db_identifier = "my-app-db"
  environment   = "dev"

  # ---------------------------------------------------
  # Engine
  # ---------------------------------------------------
  engine         = "postgres"
  engine_version = "16.4"
  instance_class = "db.t3.micro"
  db_name        = "appdb"
  username       = "postgres"

  # ---------------------------------------------------
  # Password — managed by Secrets Manager (recommended)
  # Retrieve with: aws secretsmanager get-secret-value \
  #   --secret-id <master_user_secret_arn> \
  #   --query SecretString --output text | jq -r .password
  # ---------------------------------------------------
  manage_master_user_password = true

  # ---------------------------------------------------
  # Storage
  # ---------------------------------------------------
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  # ---------------------------------------------------
  # Network
  # ---------------------------------------------------
  subnet_ids          = var.subnet_ids
  create_subnet_group = true
  publicly_accessible = false

  # Multi-AZ: false for dev (saves cost), true for prod
  multi_az = false

  vpc_id                = var.vpc_id
  create_security_group = true

  security_group_ingress_rules = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "PostgreSQL from within VPC"
    }
  ]

  security_group_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]

  # ---------------------------------------------------
  # Backup
  # ---------------------------------------------------
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  skip_final_snapshot     = true # Set false in prod!
  copy_tags_to_snapshot   = true

  # ---------------------------------------------------
  # Maintenance
  # ---------------------------------------------------
  maintenance_window         = "sun:04:00-sun:05:00"
  auto_minor_version_upgrade = true

  # ---------------------------------------------------
  # Monitoring — Enhanced Monitoring disabled (AWS Academy)
  # Set enhanced_monitoring_enabled = true in regular accounts
  # ---------------------------------------------------
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  enhanced_monitoring_enabled           = false
  create_monitoring_role                = false

  # ---------------------------------------------------
  # Security
  # ---------------------------------------------------
  deletion_protection                 = true
  iam_database_authentication_enabled = true

  # ---------------------------------------------------
  # Tags
  # ---------------------------------------------------
  tags = {
    Project    = "my-app"
    Owner      = "platform-team"
    CostCenter = "engineering"
  }
}
