# Terraform state file S3 bucket
module "terraform_state_file_storage" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "terraform-state-file-storaget"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    enabled = true
  }
}