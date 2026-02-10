# =============================================================================
# DB Subnet Group
# =============================================================================

resource "aws_db_subnet_group" "this" {
  count = var.create_db_instance && var.create_subnet_group && length(var.subnet_ids) > 0 ? 1 : 0

  name        = "${local.db_identifier}-subnet-group"
  description = "Database subnet group for ${local.db_identifier}"
  subnet_ids  = var.subnet_ids

  tags = merge(
    local.common_tags,
    var.db_subnet_group_tags,
    {
      Name = "${local.db_identifier}-subnet-group"
    }
  )
}
