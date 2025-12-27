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

module "asg" {
  source = "../../modules/asg"

  project_name = "terraform-aws-stack"
  environment  = "dev"

  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.public_subnet_ids

  instance_type    = "t3.micro"
  desired_capacity = 3
  min_size         = 1
  max_size         = 3
}

//Called ALB

module "alb" {
  source = "../../modules/alb"

  project_name = "terraform-aws-stack"
  environment  = "dev"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  asg_name          = module.asg.asg_name
}
