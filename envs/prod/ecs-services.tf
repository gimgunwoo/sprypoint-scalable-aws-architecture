locals {
  private_service_name = "${var.env}-backend"
  public_service_name = "${var.env}-frontend"
  backend_container_port = 8080
  frontend_container_port = 3000
}

module "stage_private_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "${var.env}-${local.private_service_name}-service"
  cluster_arn = module.ecs_fargate_stage_cluster.cluster_arn

  cpu    = 512
  memory = 1048

  # explicitly set to 1 even though it's by default for the vis
  desired_count = 1
  # max number of tasks set to 3, autoscale policies are predefined by the module
  # https://github.com/terraform-aws-modules/terraform-aws-ecs/blob/master/modules/service/variables.tf#L598
  autoscaling_max_capacity = 3

  # Enables ECS Exec
  enable_execute_command = true

  # Container definition(s)
  container_definitions = {
    # there should be log router and sidecar containers for datadog but let's ignore in this example..
    (local.private_service_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "public.ecr.aws/aws-containers/ecsdemo-nodejs:latest"
      port_mappings = [
        {
          name          = local.private_service_name
          containerPort = local.backend_container_port
          hostPort      = local.backend_container_port
          protocol      = "tcp"
        }
      ]
    }
  }

  # use cloudmap service name for service discovery
  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.backend_container_port
        dns_name = local.private_service_name
      }
      port_name      = local.private_service_name
      discovery_name = local.private_service_name
    }
  }

  # run the tasks in the private subnets
  subnet_ids = module.vpc.private_subnets
}

module "stage_public_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "${var.env}-${local.public_service_name}-service"
  cluster_arn = module.ecs_fargate_stage_cluster.cluster_arn

  cpu    = 512
  memory = 1048

  # explicitly set to 1 even though it's by default for the vis
  desired_count = 1
  # max number of tasks set to 5, autoscale policies are predefined by the module
  # https://github.com/terraform-aws-modules/terraform-aws-ecs/blob/master/modules/service/variables.tf#L598
  autoscaling_max_capacity = 5

  # Enables ECS Exec
  enable_execute_command = true

  # Container definition(s)
  container_definitions = {
    # there should be log router and sidecar containers for datadog but let's ignore in this example..
    (local.public_service_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:latest"
      port_mappings = [
        {
          name          = local.public_service_name
          containerPort = local.frontend_container_port
          hostPort      = local.frontend_container_port
          protocol      = "tcp"
        }
      ]

      # ALB created from alb.tf
      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["target_groups"].arn
          container_name   = local.public_service_name
          container_port   = local.frontend_container_port
        }
      }
    }
  }

  # run the tasks in the public subnets
  subnet_ids = module.vpc.public_subnets
}