data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

# Creating a role to assume role, allow admin access
# this role can be used to publish images in ECR. check ecr.tf
module "iam_terraform_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${local.aws_account_id}:root",
  ]

  create_role = true

  role_name         = "Terraform"
  role_requires_mfa = true

  attach_admin_policy = true
}