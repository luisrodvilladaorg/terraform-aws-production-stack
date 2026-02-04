module "networking" {
  source = "../../modules/networking"

  project_name = "terraform-aws-stack"
  environment  = "dev"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]

  availability_zones = [
    "eu-west-3a",
    "eu-west-3b",
    "eu-west-3c"
  ]
}

//Called module ASG

module "iam" {
  source = "../../modules/iam"

  project_name = "terraform-aws-stack"
  environment  = "dev"
}

module "asg" {
  source = "../../modules/asg"

  project_name = "terraform-aws-stack"
  environment  = "dev"

  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.public_subnet_ids

  instance_type         = "t3.micro"
  desired_capacity      = 1
  min_size              = 1
  max_size              = 3
  instance_profile_name = module.iam.instance_profile_name
  alb_security_group_id = module.alb.alb_security_group_id

  //Variables for database
  db_host     = module.rds.endpoint
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}



module "s3" {
  source = "../../modules/s3"

  project_name = "terraform-aws-stack"
  environment  = "dev"

  force_destroy    = true
  static_site_path = "${path.root}/../../state-site"
}

module "alb" {
  source = "../../modules/alb"

  project_name = "terraform-aws-stack"
  environment  = "dev"

  vpc_id               = module.networking.vpc_id
  public_subnet_ids    = module.networking.public_subnet_ids
  asg_name             = module.asg.asg_name
  alb_logs_bucket_name = module.s3.alb_logs_bucket_name
}

//CALLED RDS

module "rds" {
  source = "../../modules/rds"

  project_name = "terraform-aws-stack"
  environment  = "dev"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids

  asg_security_group_id = module.asg.asg_security_group_id

  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}


//Security group for ECS tasks

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.networking.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.alb.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-sg"
  }
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name
  environment  = var.environment
  region       = "eu-west-3"

  cluster_name = "${var.project_name}-${var.environment}-cluster"

  ecr_repository_url = module.ecr_backend.repository_url
  container_port     = 80
  desired_count      = 1

  subnet_ids        = module.networking.public_subnet_ids
  security_group_id = aws_security_group.ecs.id

  target_group_arn = module.alb.ecs_target_group_arn

  depends_on = [
    module.alb
  ]
}
