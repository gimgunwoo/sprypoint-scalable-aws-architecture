locals {
  domain_name = "${var.stage_namespace}.com"
}

module "thisisjustastage_cert" {
  source  = "terraform-aws-modules/acm/aws"

  domain_name  = local.domain_name
  zone_id      = "<some zone>"

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${local.domain_name}",
    "subdomain.${local.domain_name}",
  ]

  wait_for_validation = true
}