locals {
  iam_terraform_role_arn = module.iam_terraform_role.iam_role_arn
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "private"
  
  repository_read_write_access_arns = ["${local.iam_terraform_role_arn}"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}