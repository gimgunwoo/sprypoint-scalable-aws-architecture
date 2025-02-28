# RDS security group
module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "${local.rds_name}-sg"
  description = "Replica PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}

# Private ECS service security group
# let's assume the application port is 8080
module "private_ecs_task_security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "${local.private_service_name}-sg"
  description = "Private ECS service security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_source_security_group_id = [
    {
      description = "Access to private ECS tasks from public ECS tasks"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      source_security_group_id = module.public_ecs_task_security_group.security_group_id
    },
  ]

  # egress
  egress_with_cidr_blocks = [
    {      
      description = "Allow outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

# Public ECS service security group
# allow http and https from the internet
module "public_ecs_task_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"

  name        = "${local.public_service_name}-sg"
  description = "Public ECS service security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_rules = ["http-80-tcp", "https-443-tcp"]

  # egress
  egress_rules = ["all-all"]
  egress_with_source_security_group_id = [
    {
      description = "Allow outbound traffic to private ECS tasks"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      source_security_group_id = module.private_ecs_task_security_group.security_group_id
    },
  ]
}