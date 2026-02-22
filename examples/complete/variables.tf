variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group (min 2, different AZs)"
  type        = list(string)
}
