# ========================================
# PRODUCTION ENVIRONMENT
# ========================================
# Higher capacity, Multi-AZ, and production-grade settings

module "networking" {
  source = "../../modules/networking"

  project_name = "terraform-aws-stack"
  environment  = "prod"

  vpc_cidr = "10.1.0.0/16"  # Different CIDR from dev

  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.1.101.0/24",
    "10.1.102.0/24",
    "10.1.103.0/24"
  ]

  availability_zones = [
    "eu-west-3a",
    "eu-west-3b",
    "eu-west-3c"
  ]
}

module "iam" {
  source = "../../modules/iam"

  project_name = "terraform-aws-stack"
  environment  = "prod"
}

module "asg" {
  source = "../../modules/asg"

  project_name = "terraform-aws-stack"
  environment  = "prod"

  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.public_subnet_ids

  # Production: larger instances, higher capacity
  instance_type    = "t3.small"
  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  instance_profile_name = module.iam.instance_profile_name
  alb_security_group_id = module.alb.alb_security_group_id

  # Database connection
  db_host     = module.rds.endpoint
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}

module "s3" {
  source = "../../modules/s3"

  project_name = "terraform-aws-stack"
  environment  = "prod"

  # Production: prevent accidental deletion
  force_destroy    = false
  static_site_path = "${path.root}/../../state-site"
}

module "alb" {
  source = "../../modules/alb"

  project_name = "terraform-aws-stack"
  environment  = "prod"

  vpc_id               = module.networking.vpc_id
  public_subnet_ids    = module.networking.public_subnet_ids
  asg_name             = module.asg.asg_name
  alb_logs_bucket_name = module.s3.alb_logs_bucket_name
}

module "rds" {
  source = "../../modules/rds"

  project_name = "terraform-aws-stack"
  environment  = "prod"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids

  asg_security_group_id = module.asg.asg_security_group_id

  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password

  # Production configuration: Multi-AZ for HA
  multi_az                = true  # 2 AZ with automatic failover
  backup_retention_period = 30    # Extended backup retention
}
