# Production Environment - README

## Overview
This directory contains the **production** environment configuration for the AWS infrastructure.

## Key Differences from Dev

| Configuration | Dev | Production |
|--------------|-----|------------|
| VPC CIDR | `10.0.0.0/16` | `10.1.0.0/16` |
| Instance Type | t3.micro | **t3.small** |
| ASG Min/Desired/Max | 1/1/3 | **2/2/4** |
| RDS Instance | db.t3.micro | **db.t3.small** |
| Force Destroy | true | **false** |
| State File | `dev/terraform.tfstate` | `prod/terraform.tfstate` |

## Deployment

### Prerequisites
1. Configure AWS credentials
2. Ensure S3 backend bucket exists
3. Create `terraform.tfvars` from `terraform.tfvars.example`

### Commands

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan changes
terraform plan -out=tfplan

# Apply (requires manual approval)
terraform apply tfplan

# Destroy (use with caution!)
terraform destroy
```

## Security Notes

⚠️ **IMPORTANT**: 
- Never commit `terraform.tfvars` to Git
- Use strong passwords for database
- Consider using AWS Secrets Manager for credentials
- Review all changes before applying to production

## Outputs

After deployment, retrieve important values:

```bash
# Get ALB URL
terraform output alb_dns_name

# Get all outputs
terraform output
```

## Cost Estimate

Expected monthly cost: **~$120-150**
- Higher instance types
- Increased capacity
- Additional monitoring
