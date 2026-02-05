# 🚀 AWS Production Infrastructure - Terraform

> Enterprise-grade, multi-AZ AWS architecture following industry best practices and security standards.

![CI](https://github.com/luisrodvilladaorg/terraform-aws-production-stack/actions/workflows/terraform-ci.yml/badge.svg)
![CD](https://github.com/luisrodvilladaorg/terraform-aws-production-stack/actions/workflows/terraform-cd.yml/badge.svg)
[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Infrastructure](https://img.shields.io/badge/Infrastructure-as_Code-blue)

Production-ready AWS infrastructure built with Terraform. Demonstrates DevOps best practices, modular architecture, and cloud security fundamentals.

---

## 🎯 Key Features

- ✅ **Multi-AZ High Availability** - 3 availability zones with automatic failover
- ✅ **Auto Scaling** - Elastic compute responding to load (1-3 instances)
- ✅ **Private Database** - PostgreSQL RDS isolated in private subnets
- ✅ **Load Balancing** - Application Load Balancer with health checks
- ✅ **Modular Design** - Reusable Terraform modules for each component
- ✅ **Security First** - Least-privilege IAM, security groups, encrypted state
- ✅ **Cost Optimized** - ~$85/month for complete production-like environment

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   AWS Region (eu-west-3)                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           VPC (10.0.0.0/16)                          │   │
│  │                                                       │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐    │   │
│  │  │   Public   │  │   Public   │  │   Public   │    │   │
│  │  │  Subnet A  │  │  Subnet B  │  │  Subnet C  │    │   │
│  │  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘    │   │
│  │        │               │               │            │   │
│  │        └───────────────┴───────────────┘            │   │
│  │                        │                            │   │
│  │          ┌─────────────▼─────────────┐              │   │
│  │          │  Application Load Balancer│              │   │
│  │          └─────────────┬─────────────┘              │   │
│  │                        │                            │   │
│  │          ┌─────────────▼─────────────┐              │   │
│  │          │   Auto Scaling Group      │              │   │
│  │          │   (1-3 EC2 instances)     │              │   │
│  │          └─────────────┬─────────────┘              │   │
│  │                        │                            │   │
│  │  ┌────────────┐  ┌────┴───────┐  ┌────────────┐    │   │
│  │  │  Private   │  │  Private   │  │  Private   │    │   │
│  │  │ Subnet A   │  │ Subnet B   │  │ Subnet C   │    │   │
│  │  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘    │   │
│  │        └───────────────┴───────────────┘            │   │
│  │                        │                            │   │
│  │          ┌─────────────▼─────────────┐              │   │
│  │          │   RDS PostgreSQL Multi-AZ │              │   │
│  │          └───────────────────────────┘              │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

**Components:**
- VPC with 6 subnets (3 public, 3 private) across 3 AZs
- Internet Gateway + NAT Gateway
- Application Load Balancer with target groups
- Auto Scaling Group (t3.micro Spot instances)
- RDS PostgreSQL (db.t3.micro, Multi-AZ ready)
- S3 buckets (static site + ALB logs)
- IAM roles with least-privilege policies
- CloudWatch monitoring (future)

---

## 📦 Terraform Modules

```
modules/
├── networking/    # VPC, subnets, gateways, routing
├── alb/          # Load balancer, target groups, listeners
├── asg/          # Auto Scaling, launch templates
├── rds/          # PostgreSQL database, subnet groups
├── s3/           # Storage buckets, policies
└── iam/          # Roles, policies, instance profiles

envs/
├── dev/          # Development environment
└── prod/         # Production (planned)
```

---

## 🚀 Quick Start

### Prerequisites
- Terraform >= 1.5.0
- AWS CLI configured
- S3 bucket for remote state

### Deploy in 5 Steps

```bash
# 1. Clone repository
git clone <repo-url>
cd terraform-aws-production-stack/envs/dev

# 2. Configure variables
cat > terraform.tfvars <<EOF
project_name = "my-stack"
environment  = "dev"
db_name      = "appdb"
db_user      = "admin"
db_password  = "ChangeMe123!"
EOF

# 3. Initialize Terraform
terraform init

# 4. Review plan
terraform plan

# 5. Deploy infrastructure
terraform apply
```

**Deployment time:** ~8 minutes  
**Resources created:** 30+

### Verify Deployment

```bash
# Get ALB URL
terraform output alb_dns_name

# Test application
curl http://$(terraform output -raw alb_dns_name)

# Test API endpoint
curl http://$(terraform output -raw alb_dns_name)/api/ping
```

---

## 🎨 Infrastructure Highlights

### 🔒 Security
- **Zero public database access** - RDS in private subnets only
- **Security groups** - Least-privilege ingress/egress rules
- **IAM roles** - No hardcoded credentials on instances
- **Encrypted state** - S3 backend with SSE
- **Environment validation** - Prevents accidental production deployments

### 🌍 High Availability
- **Multi-AZ deployment** - Spans 3 availability zones
- **Auto Scaling** - Automatic instance replacement
- **Health checks** - ALB monitors instance health
- **RDS standby** - Multi-AZ database failover ready

### 💡 Best Practices
- **Modular architecture** - DRY principle, reusable components
- **Remote state** - S3 + DynamoDB for team collaboration
- **Consistent tagging** - All resources tagged (Environment, Project, ManagedBy)
- **Variable validation** - Input validation prevents errors
- **Comprehensive outputs** - Easy integration with other tools

---

## 💰 Cost Breakdown

| Component | Spec | Monthly Cost |
|-----------|------|--------------|
| EC2 (ASG) | 1x t3.micro | $7.50 |
| RDS | db.t3.micro | $15.00 |
| ALB | Standard | $16.00 |
| NAT Gateway | 1x + data | $35.00 |
| S3 + Data | Minimal usage | $6.00 |
| CloudWatch | Logs/Metrics | $2.00 |
| **TOTAL** | | **~$81.50** |

**Cost optimization tips:**
- Use Spot instances (save 70%)
- Schedule ASG for business hours only
- Delete old logs (lifecycle policies)
- Consider VPC endpoints to bypass NAT

---

## 🛠️ Technical Stack

**Infrastructure:** Terraform 1.5+, AWS  
**Compute:** EC2 Auto Scaling (Amazon Linux 2)  
**Database:** PostgreSQL 15.15 (RDS)  
**Storage:** S3  
**Networking:** VPC, ALB, NAT Gateway  
**Backend:** Node.js Express API  
**Frontend:** Static HTML/CSS site

---

## 📊 Outputs

All modules export comprehensive outputs with descriptions:

```hcl
# Environment outputs (20+ values)
- alb_dns_name              # Load balancer URL
- application_url           # Full HTTP URL
- api_health_check          # Health check endpoint
- db_health_check           # Database connectivity test
- vpc_id                    # VPC identifier
- asg_name                  # Auto Scaling Group name
- static_bucket             # S3 bucket name
- And more...
```

---

## 🔄 CI/CD Integration

**Status:** 🚧 Planned

GitHub Actions workflow for automated deployments:
- `terraform fmt` + `validate` on PRs
- Security scanning (tfsec, checkov)
- Automated plan comments on PRs
- Auto-deploy to dev on merge to `main`
- Manual approval for production

---

## 📚 Documentation

- **[Deployment Examples](docs/examples.md)** - Real-world deployment scenarios
- **[Module Documentation](modules/)** - Individual module READMEs
- **[Commands Reference](docs/commands.md)** - Common Terraform commands

---

## 🎯 Future Enhancements

- [ ] AWS Secrets Manager for credential management
- [ ] CloudWatch dashboards and alarms
- [ ] SSL/TLS with ACM certificates
- [ ] Route53 DNS management
- [ ] CloudFront CDN distribution
- [ ] ECS/Fargate containerization
- [ ] Multi-region deployment
- [ ] Automated testing with Terratest

---

## 📝 License

MIT License - Free to use and modify

---

## 👨‍💻 About

Built as a demonstration of production-grade Infrastructure as Code practices. Showcases expertise in:

- ☁️ Cloud Architecture (AWS)
- 🔧 Infrastructure as Code (Terraform)
- 🔐 Security & Compliance
- 📈 Scalability & High Availability
- 💰 Cost Optimization
- 🏗️ DevOps Best Practices

**Perfect for:** DevOps portfolios, learning Terraform, AWS certification prep, or as a foundation for real production workloads.

---

⭐ **Star this repo** if you find it useful!