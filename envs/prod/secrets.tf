# Random string RDS master instance password stored in AWS SSM
resource "aws_ssm_parameter" "master_password" {
  count       = var.password == null && var.replicate_source_db == null ? 1 : 0
  description = "${local.rds_name}-master database password"
  name        = "${local.rds_name}-master"
  type        = "String"
  value       = element(random_string.password[*].result, count.index)

  tags = {
    Name      = "${local.rds_name}-master"
    env       = var.env
  }
  depends_on = [
    random_string.password
  ]
}