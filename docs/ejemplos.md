# 🚀 Deployment Examples

Quick-start examples to deploy AWS infrastructure with Terraform.

---

## ⚡ Quick Deployment (5 Minutes)

End-to-end deployment from zero to running infrastructure.

### Prerequisites
```bash
terraform --version  # >= 1.5.0
aws sts get-caller-identity  # Verify AWS access
```

### Deployment Steps

```bash
# 1. Go to the environment
cd envs/dev

# 2. Create configuration
cat > terraform.tfvars <<EOF
project_name = "my-stack"
environment  = "dev"
db_name      = "appdb"
db_user      = "admin"
db_password  = "SecurePassword123!"  # KEEP THIS FILE OUT OF GIT
EOF

# 3. Initialize and deploy
terraform init
terraform plan
terraform apply -auto-approve

# ⏱️ Wait ~8 minutes for deployment
```

### Verify Deployment

```bash
# Get application URL
ALB_URL=$(terraform output -raw alb_dns_name)

# Test static site
curl http://$ALB_URL

# Test API
curl http://$ALB_URL/api/ping
# Response: {"status":"ok","host":"ip-10-0-x-x"}

# Test database connectivity
curl http://$ALB_URL/api/ping-db
# Response: {"status":"ok","time":"2026-02-04T..."}
```

**Result:** 30+ AWS resources deployed and validated ✅

---

## 💰 Cost-Optimized Configuration

Minimal-cost configuration for testing (~$50/month).

### Changes

Edit `envs/dev/main.tf`:

```hcl
module "asg" {
  source = "../../modules/asg"
  
  # ... other variables ...
  
  instance_type    = "t3.micro"
  desired_capacity = 1
  min_size         = 1
  max_size         = 1  # No auto-scaling
}

module "rds" {
  source = "../../modules/rds"
  
  # ... other variables ...
  
  instance_class    = "db.t3.micro"
  allocated_storage = 20  # Minimum storage
}
```

**Savings:** ~40% lower monthly cost

---

## 🏢 Production-Ready Configuration

High-availability setup for production workloads.

### terraform.tfvars
```hcl
project_name = "production-app"
environment  = "prod"

# Secure credentials (use AWS Secrets Manager in real prod)
db_name     = "production_db"
db_user     = "prod_admin"
db_password = "StrongPassword!2026"
```

### Enhanced ASG Configuration

```hcl
module "asg" {
  source = "../../modules/asg"
  
  # ... other variables ...
  
  instance_type    = "t3.small"
  desired_capacity = 3  # Always 3 instances
  min_size         = 2  # Minimum for HA
  max_size         = 6  # Scale up to 6
}
```

**Cost:** ~$180-220/month  
**Benefits:** High availability, auto-scaling, multi-AZ

---

## 🔍 Monitoring and Validation

### Verify Infrastructure State

```bash
# List all created resources
terraform state list

# Show a specific resource
terraform state show module.networking.aws_vpc.this

# Print all outputs
terraform output
```

### Verification with AWS CLI

```bash
# Check VPC
aws ec2 describe-vpcs \
  --filters "Name=tag:Project,Values=my-stack" \
  --region eu-west-3

# Check ASG health
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names my-stack-dev-asg \
  --region eu-west-3

# Check RDS status
aws rds describe-db-instances \
  --db-instance-identifier my-stack-dev-postgres \
  --region eu-west-3 \
  --query 'DBInstances[0].DBInstanceStatus'

# List running EC2 instances
aws ec2 describe-instances \
  --filters "Name=tag:Environment,Values=dev" \
            "Name=instance-state-name,Values=running" \
  --region eu-west-3 \
  --query 'Reservations[].Instances[].[InstanceId,State.Name]' \
  --output table
```

---

## 🛠️ Common Scenarios

### Update Application Code

```bash
# 1. Modify user-data in modules/asg/main.tf
# 2. Apply changes
terraform apply

# Terraform will:
# - Create a new launch template version
# - Gradually roll instances (no downtime)
```

### Scale Up/Down

```bash
# Edit terraform.tfvars
desired_capacity = 5
max_size         = 10

# Apply
terraform apply
```

### Change Database Password

```bash
# Edit terraform.tfvars
db_password = "MyNewSecurePassword123!"

# Apply (triggers DB modification)
terraform apply
```

---

## 🚨 Troubleshooting

### Issue: ALB returns 502 Bad Gateway

**Cause:** Instances are not ready yet  
**Fix:** Wait 2-3 minutes for user-data script completion

```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)
```

### Issue: Cannot connect to RDS

**Cause:** Incorrect security group configuration  
**Fix:** Verify ASG security group is allowed in RDS ingress rules

```bash
# Check security group outputs
terraform output | grep security_group
```

### Issue: High Costs

**Cause:** Oversized compute/database settings  
**Fix:** Use dev sizing and scheduling in non-production environments

---

## 🧹 Cleanup

### Destroy Infrastructure

```bash
# Preview destruction
terraform plan -destroy

# Destroy all resources
terraform destroy -auto-approve

# Verify cleanup
aws ec2 describe-vpcs \
  --filters "Name=tag:Project,Values=my-stack" \
  --region eu-west-3
```

⚠️ **Important:** This permanently deletes ALL resources.

---

## 🎯 Advanced Scenarios

### Multi-Environment Deployment

```bash
# Deploy dev
cd envs/dev
terraform workspace new dev
terraform apply -var-file="dev.tfvars"

# Deploy staging
terraform workspace new staging
terraform apply -var-file="staging.tfvars"

# List workspaces
terraform workspace list
```

### Custom VPC CIDR

```hcl
# In main.tf
module "networking" {
  source = "../../modules/networking"
  
  vpc_cidr = "172.16.0.0/16"  # Custom range
  
  public_subnet_cidrs = [
    "172.16.1.0/24",
    "172.16.2.0/24",
    "172.16.3.0/24"
  ]
  
  private_subnet_cidrs = [
    "172.16.101.0/24",
    "172.16.102.0/24",
    "172.16.103.0/24"
  ]
}
```

---

## 📊 Cost Estimation

Before deploying, estimate costs:

```bash
# Use AWS Pricing Calculator
# Open: https://calculator.aws/

# Or use Infracost CLI
infracost breakdown --path envs/dev
```

**Expected costs:**
- **Dev:** ~$81/month
- **Prod (HA):** ~$180/month

---

## 🔗 Additional Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Pricing Calculator](https://calculator.aws/)
- [Main README](../README.md)

---

**💡 Pro Tip:** Always run `terraform plan` before `apply` to review changes.
