terraform {
  backend "s3" {
    bucket         = "terraform-state-file-storaget"
    key            = "path/to/prod/main.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "tf_state_lock"
  }
}