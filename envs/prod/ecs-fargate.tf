module "ecs_fargate_prod_cluster" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-fargate-prod-cluster"
  
  # Fargate Spot for prod environment for cost optimization
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 0
        base   = 0
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 1
        base   = 1
      }
    }
  }
}