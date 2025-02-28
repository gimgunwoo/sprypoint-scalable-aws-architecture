#providers
provider "aws" {
  region = var.aws-region

  default_tags {
    tags = var.default_tags
  }
}