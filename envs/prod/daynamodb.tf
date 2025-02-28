# DynamoDB Terraform State Lock Table
resource "aws_dynamodb_table" "terraform-lock" {
  name           = "tf_state_lock"
  read_capacity  = 10
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}