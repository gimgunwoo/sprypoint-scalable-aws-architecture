locals {
  alb_arns = module.alb.arn
}

module "label" {
  source = "cloudposse/label/null"

  namespace = "sprypoint"
  stage     = "stage"
  name      = "waf"
  delimiter = "-"
}

module "waf" {
  source = "cloudposse/waf/aws"

  # associate ALB we created in alb.tf
  association_resource_arns = [ local.alb_arns ]

  visibility_config = {
    cloudwatch_metrics_enabled = false
    metric_name                = "sprypoint-rules-metric"
    sampled_requests_enabled   = false
  }

  # some geo match statement rules
  geo_match_statement_rules = [
    {
      name     = "rule-10"
      action   = "count"
      priority = 10

      statement = {
        country_codes = ["NL", "GB", "US"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = false
        metric_name                = "rule-10-metric"
      }
    },
    {
      name     = "rule-11"
      action   = "block"
      priority = 11

      statement = {
        country_codes = ["KP"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = false
        metric_name                = "rule-11-metric"
      }
    }
  ]

  context = module.label.context
}