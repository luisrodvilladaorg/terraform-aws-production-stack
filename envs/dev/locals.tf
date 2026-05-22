locals {
  project_name = "terraform-aws-stack"
  environment  = "dev"

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
    Owner       = "luis"
  }

  name_prefix = "${local.project_name}-${local.environment}"
}
