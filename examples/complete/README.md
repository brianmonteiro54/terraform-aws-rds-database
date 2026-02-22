# Example: Complete RDS PostgreSQL Instance

This example provisions a production-ready RDS PostgreSQL instance following AWS best practices.

## What is created

- RDS PostgreSQL 16.4 instance (`db.t3.micro`)
- DB subnet group across the provided subnets
- Security group allowing PostgreSQL (5432) from within the VPC only
- Master password managed automatically by AWS Secrets Manager
- Storage encrypted with AWS-managed key
- Performance Insights enabled (7-day free retention)
- Automated daily backups with 7-day retention
- Deletion protection enabled

## Usage

```bash
terraform init

terraform plan \
  -var="vpc_id=vpc-xxxxxxxxxxxxxxxxx" \
  -var='subnet_ids=["subnet-aaa","subnet-bbb"]'

terraform apply \
  -var="vpc_id=vpc-xxxxxxxxxxxxxxxxx" \
  -var='subnet_ids=["subnet-aaa","subnet-bbb"]'
```

## Retrieving the master password

```bash
aws secretsmanager get-secret-value \
  --secret-id $(terraform output -raw master_user_secret_arn) \
  --query SecretString --output text | jq -r .password
```

## Connecting

```bash
psql -h $(terraform output -raw db_instance_address) \
     -p 5432 \
     -U postgres \
     -d appdb
```

## Inputs

| Name | Description | Required |
|------|-------------|----------|
| vpc_id | VPC ID for the security group | Yes |
| subnet_ids | List of private subnet IDs (min 2, different AZs) | Yes |
| aws_region | AWS region | No (default: `us-east-1`) |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_endpoint | Connection endpoint (host:port) |
| master_user_secret_arn | Secrets Manager ARN for the password |
| get_password_command | Ready-to-use CLI command to fetch the password |
| security_group_id | Security group ID |
| connection_string_psql | Example psql command |

> **AWS Academy note:** `enhanced_monitoring_enabled` is set to `false` because
> AWS Academy restricts IAM role creation. Set to `true` with `create_monitoring_role = true`
> in regular AWS accounts for production workloads.

> **Production checklist:** Set `multi_az = true`, `skip_final_snapshot = false`,
> and increase `backup_retention_period` to at least 14 days.
