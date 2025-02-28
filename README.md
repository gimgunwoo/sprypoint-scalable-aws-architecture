# Sprypoint scalable AWS architecture

## Objectives
Design a scalable, automated AWS architecture to host this application. The architecture should cover the entire lifecycle—from repository to production. You are free to use any tools and services that you feel will best meet the requirements. The solution should reflect AWS best practices according to the Well Architected Framework, especially for high availability, security, scalability, and cost-efficiency.

## Limitations, disclosure
* There will be no GitHub Actions workflows.
* Terraform wasn't tested because this will be an example. There must be failures if the plan is run.
* There won't be custom Terraform modules because the main focus on this repo is an AWS architecture managed by Terraform, not how a custom module can be written.
* Pre commit Terraform hooks for format, validate and docs won't be installed and used so there will be missing READMEs and terraform codes won't be validated and nicely formatted. If you need to know more about pre commit hooks, then follow [this repo](https://github.com/antonbabenko/pre-commit-terraform).
* This repo will be removed after the presentation.

## Sources
https://docs.aws.amazon.com/

https://docs.aws.amazon.com/wellarchitected/

https://github.com/antonbabenko/pre-commit-terraform

https://github.com/terraform-aws-modules

https://github.com/cloudposse/terraform-aws-waf

https://www.datadoghq.com/architecture/using-datadog-with-ecs-fargate/