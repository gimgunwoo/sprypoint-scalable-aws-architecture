locals {
  domain_name = "${var.prod_namespace}.com"
}

module "thisisjustaprod_cert" {
  source  = "terraform-aws-modules/acm/aws"

  domain_name  = local.domain_name
  zone_id      = "<some zone id>"

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${local.domain_name}",
    "subdomain.${local.domain_name}",
  ]

  wait_for_validation = true
}