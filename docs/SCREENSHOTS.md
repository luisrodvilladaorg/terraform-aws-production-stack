# 📸 Screenshot Gallery - AWS Infrastructure Deployment

> Complete screenshot collection of deployment, configuration, and operations for Terraform infrastructure on AWS.

[← Back to README](../README.md)

---

## 📸 Deployment Screenshots

### 1. 🏗️ Terraform Init - Project Initialization
![Terraform init](images/terraform-init.png)

*Terraform initialization process with provider and module downloads. The remote S3 backend is configured and the environment is prepared to manage infrastructure as code.*

### 3. 📦 Terraform Plan - Resource Summary by Type
![Resources Overview](images/Resources.png)

*Overview of AWS resource types grouped by service (EC2, RDS, S3, etc.).*

---

### 4. 📦 AWS Resources 2 - Additional Networking Module Details
![Resources Detail 2](images/Resources2.png)

*Additional resource details including availability, status, and configuration specifics.*

---

### 5. 📦 AWS Resources 3 - ALB & RDS
![Resources Network](images/Resources3.png)

*Detailed network resources including VPC, subnets, route tables, and NAT Gateway configuration.*

### 6. 📦 AWS Resources 4 - RDS Resources
![Resources Compute](images/Resources.4.png)

*Compute resources including Auto Scaling Group, Launch Templates, and EC2 instance configuration.*

### 7. 📦 Terraform Plan Complete - 80+ Resources
![Resources Database](images/Resources.5.png)

*RDS PostgreSQL database resources with Multi-AZ configuration, snapshots, and security parameters.*

### 8. 🧹 Terraform Destroy - Infrastructure Cleanup
![Terraform Destroy](images/terraform-destroy.png)

*Controlled execution of `terraform destroy`, demonstrating full infrastructure teardown. Shows how all 80+ resources are safely released with one command.*

*The following screenshots show deployed resources directly in the AWS Console.*

---

### 3. 🔀 Route Tables - Traffic Routing
![Route Tables](images/route-tables.png)

*Public and private route table configuration. Shows traffic routing to Internet Gateway (public) and NAT Gateway (private), enabling controlled private-subnet egress.*

---

### 4. 🔐 Subnets - Layer Isolation
![Subnets Configuration](images/subnets.png)

*Detail of the 6 subnets and CIDR blocks. Shows availability-zone distribution (AZa, AZb, AZc) and route table associations.*

---

### 5. 🛡️ Security Groups - Firewall and Access Control
![Security Groups](images/security-groups.png)

*First security group configuration with ingress and egress rules. Implements least privilege by allowing only specific inter-layer traffic.*

---

### 6. 🛡️ Additional Security Groups - Component Isolation
![Security Groups 2](images/security-groups2.png)

*Second set of security group rules for specific components (ALB, EC2, RDS). Shows full layer isolation and port restrictions.*

---

### 7. ⚖️ Application Load Balancer - Load Distribution
![ALB Configuration](images/alb.png)

*Application Load Balancer configuration with networking details, associated subnets, and security groups. Prepares traffic distribution across EC2 instances.*

---

### 8. 🎯 ALB Listeners - Port Configuration
![ALB Listeners](images/listeners.png)

*ALB listeners configured for ports 80 (HTTP) and 443 (HTTPS), with dynamic target groups and routing rules.*

---

### 9. 🌐 ALB Endpoint - Access URL
![ALB Working](images/alb-working.png)

*Fully operational ALB with generated DNS and active status. Shows full application URL and passing health checks.*

---

### 10. 📍 ALB Endpoint URL - Entry Point
![ALB Endpoint](images/alb-endpoint.png)

*AWS-generated ALB endpoint following standard naming pattern. Provides external access with automatic load balancing.*

---

### 11. 🖥️ EC2 Instances - Running Compute
![EC2 Instances](images/ec2-instances.png)

*Active EC2 t3.micro instances in running state, including availability zone assignment and private VPC connectivity.*

---

### 12. 🔄 Auto Scaling Group - Automatic Scaling
![ASG Configuration](images/asg.png)

*Auto Scaling Group configured with desired capacity of 1-3 instances, with scaling metrics and multi-AZ distribution.*

---

### 13. 💾 S3 General - Standard Storage
![S3 General](images/s3-general.png)

*Main S3 bucket configuration with versioning, default encryption, and access policies.*

---

### 14. 📝 S3 Logs - ALB Logs
![S3 Logs](images/s3-logs.png)

*Dedicated S3 bucket for ALB access logs with lifecycle policies for retention management.*

---

### 15. 🌐 S3 Website - Static Site
![S3 Website](images/s3-page.png)

*S3 static website hosting configuration serving HTML index and static assets (CSS, JS, images).* 

---

### 16. 📋 Terraform State List - Created Resources
![State List](images/state-list.png)

*Complete list of 80+ resources managed by Terraform, showing centralized state for AWS infrastructure.*

---

### 17. 🗂️ Folder Structure - Project Organization
![Project Folders](images/folders.png)

*Modular project structure with envs (dev, prod, stage), modules, and docs directories.*

---

### 18. 🚀 GitHub Workflows - CI/CD Pipelines
![Workflows](images/workflows.png)

*GitHub Actions workflows for automation, including terraform-ci.yml and terraform-cd.yml for validation and deployment.*

---

### 19. ⚙️ GitHub Pipelines - Execution Status
![Pipelines](images/pipelines.png)

*CI/CD pipeline execution status with validation logs, change plans, and automatic `terraform apply` in designated environments.*

---

### 20. 🧹 Terraform Destroy - Infrastructure Cleanup
![Terraform Destroy](images/terraform-destroy.png)

*Controlled `terraform destroy` execution proving safe and complete infrastructure teardown of all 80+ resources.*

---

## 📊 Screenshot Summary
| # | Description | File | Status |
|---|-------------|------|--------|
| 1 | Terraform Init | `terraform-init.png` | ✅ |
| 2 | AWS Resources | `Resources.png` | ✅ |
| 3 | AWS Resources 2 | `Resources2.png` | ✅ |
| 4 | AWS Resources 3 | `Resources3.png` | ✅ |
| 5 | AWS Resources 4 | `Resources.4.png` | ✅ |
| 6 | AWS Resources 5 | `Resources.5.png` | ✅ |
| 7 | Terraform Destroy | `terraform-destroy.png` | ✅ |

---

## 📌 Notes

- All images are high-quality PNG format
- The order reflects the deployment flow from initialization to destroy
- Descriptions include technical context and component relationships

[← Back to README](../README.md)
