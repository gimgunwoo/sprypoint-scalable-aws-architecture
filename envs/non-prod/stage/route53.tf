# create a route53 zone
module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"

  zones = {
    "${var.stage_namespace}.com" = {
      comment = "${var.stage_namespace}.com (stage)"
      tags = {
        env = "stage"
      }
    }
  }
}

# create an A record for www in the zone above
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = keys(module.zones.route53_zone_zone_id)[0]

  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      alias   = {
        name    = module.alb.dns_name
        zone_id = module.alb.zone_id
      }
    },
  ]

  depends_on = [module.zones]
}