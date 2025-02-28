locals {
  alb_name = "${var.env}-alb"
  vpc_id   = module.vpc.vpc_id
  subnets  = module.vpc.public_subnets
  cert_arn = module.thisisjustastage_cert.acm_certificate_arn
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = local.alb_name
  vpc_id  = local.vpc_id
  subnets = local.subnets

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }

  access_logs = {
    bucket = "${local.alb_name}-logs"
  }

  # Listeners and
  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = local.cert_arn

      forward = {
        target_group_key = "stage-service-target-group"
      }
    }
  }

  # When creating public ECS services, choose existing ALB and this target group
  target_groups = {
    stage-service-target-group = {
      name_prefix      = "stage"
      protocol         = "HTTP"
      port             = 3000
      target_type      = "IP"
    }

    # ALB health check
    # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html
    health_check = {
      enabled             = true
      interval            = 30
      path                = "/healthz"
      port                = "traffic-port"
      healthy_threshold   = 5
      unhealthy_threshold = 2
      timeout             = 5
      protocol            = "HTTP"
      matcher             = "200-399"
    }
  }

  depends_on = [ module.thisisjustastage_cert ]
}