module "cloudmap_services" {
  source  = "finisterra-io/cloudmap/aws"

  # cloudmap namespace
  namespace_name = "example.local"
  vpc_name       = local.vpc_name

  service_names = {
    # stage private service
    stage = {
      description = "This is just a stage backend service"
      routing_policy = "MULTIVALUE"
      dns_records = {
        ttl = 10
        type = "A"
      }
      health_check_custom_config = {
        failure_threshold = 1
      }
    }
    # prod private service
    prod = {
      description = "This is just a prod backend service"
      routing_policy = "MULTIVALUE"
      dns_records = {
        ttl = 10
        type = "A"
      }
      health_check_custom_config = {
        failure_threshold = 1
      }
    }
  }
}