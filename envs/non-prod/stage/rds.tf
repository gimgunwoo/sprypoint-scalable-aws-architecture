provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  rds_name     = "${var.env}-${local.family}"
  region   = "ca-central-1"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  engine                = "postgres"
  engine_version        = "14"
  family                = "postgres14"
  major_engine_version  = "14"
  instance_class        = "db.t4g.large"
  allocated_storage     = 20
  max_allocated_storage = 100
  port                  = 5432

  password = var.password == null && var.replicate_source_db == null ? aws_ssm_parameter.main[0].value : (var.replicate_source_db != null ? null : var.password)
}

# Postgres14 master instance
module "master_instance" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${local.rds_name}-master"

  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version
  instance_class       = local.instance_class

  allocated_storage     = local.allocated_storage
  max_allocated_storage = local.max_allocated_storage

  db_name  = "replicaPostgresql"
  username = "admin"
  port     = local.port

  password = local.password
  # Not supported with replicas
  manage_master_user_password = false

  # multi AZ set to FALSE because it's STAGE
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.rds_security_group.security_group_id]

  # Backups are required in order to create a replica
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = false
}

# No replica here