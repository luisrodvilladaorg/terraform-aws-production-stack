# Minimal Module Consumption Example: networking + alb

This is the smallest example that wires `networking` outputs into `alb` inputs.

Important:
- This example focuses on module consumption and wiring.
- The `alb` module requires `asg_name` and `alb_logs_bucket_name`.
- For a real deployment, use an existing Auto Scaling Group name and an existing S3 bucket for ALB logs.

## main.tf

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "minimal-networking-alb"
      ManagedBy   = "Terraform"
    }
  }
}

module "networking" {
  source = "../modules/networking"

  project_name = "minimal-networking-alb"
  environment  = "dev"

  vpc_cidr             = "10.50.0.0/16"
  public_subnet_cidrs  = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
  private_subnet_cidrs = ["10.50.101.0/24", "10.50.102.0/24", "10.50.103.0/24"]
  availability_zones   = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

module "alb" {
  source = "../modules/alb"

  project_name = "minimal-networking-alb"
  environment  = "dev"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  # Required by this repository's ALB module.
  # Replace with real values from your environment.
  asg_name             = "existing-asg-name"
  alb_logs_bucket_name = "existing-alb-logs-bucket"
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
```

## Run

```bash
terraform init
terraform plan
```

## Notes

- If you do not have an existing ASG yet, deploy `networking` + `asg` first.
- If you do not have an ALB logs bucket yet, create it first (or use your S3 module output).
