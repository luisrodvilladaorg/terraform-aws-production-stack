# 🔒 Security Guide

Security practices implemented in this Infrastructure as Code project.

---

## ✅ Git Repository Security

### Ignored Files (not committed)
```
# Credentials and secrets
*.tfvars            # Terraform variable files
*.tfvars.json       # JSON variable files
.env                # Environment variables
.env.*              # Environment-specific files
.secrets            # Secrets directory

# State and lock files
*.tfstate           # Terraform state
*.tfstate.*         # State backups
.terraform.lock.hcl # Terraform lock file
```

### Sensitive Variables

All sensitive variables are marked with `sensitive = true`:

```hcl
variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true  # Hidden from logs
}
```

**Never include in code:**
- Passwords
- API keys
- Tokens
- AWS credentials

---

## 🔐 Credential Management

### Local Development
```bash
# Create local file (not versioned)
cat > envs/dev/terraform.tfvars <<EOF
db_name     = "appdb"
db_user     = "appuser"
db_password = "YourSecurePassword123!"
EOF

# Never commit this file
```

### Production (Recommended)
Use **AWS Secrets Manager**:

```hcl
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db.id
}

module "rds" {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}
```

---

## 🛡️ IAM and Permissions

### Principle of Least Privilege
- ✅ IAM roles with specific permissions
- ✅ No hardcoded credentials on instances
- ✅ Instance profiles for secure AWS service access
- ✅ Restrictive security groups

### Minimal policy example
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

---

## 🔑 SSH/Key Management

### For SSH between instances
```bash
# Do NOT hardcode keys in user-data
# Use instead:
- AWS Systems Manager Session Manager
- AWS Secrets Manager for key rotation
- VPC endpoints for private communication
```

---

## 📋 Auditing and Logging

### CloudWatch Logs
```bash
# All logs centralized and encrypted
- Application logs
- ALB access logs → S3
- VPC Flow Logs (recommended)
- CloudTrail for resource changes
```

### Log Verification
```bash
# View application logs
aws logs tail /aws/ec2/app-logs --follow

# Export for audit
aws s3 cp s3://my-alb-logs/ ./logs/ --recursive
```

---

## 🔄 Credential Rotation

### RDS Password
```bash
# Change password (no downtime)
aws rds modify-db-instance \
  --db-instance-identifier my-stack-dev-postgres \
  --master-user-password NewPassword123! \
  --apply-immediately
```

### AWS Access Keys (for CI/CD)
```bash
# Rotate every 90 days
aws iam create-access-key --user-name terraform-user
aws iam delete-access-key --user-name terraform-user --access-key-id OLD_KEY
```

---

## 🚨 Secret Detection

### Pre-commit Hook
```bash
# Install git-secrets
brew install git-secrets      # macOS
apt-get install git-secrets   # Linux

# Configure repository
git secrets --install
git secrets --register-aws
```

### GitHub Secret Scanning
- ✅ Enabled by default on public repositories
- ✅ Detects and revokes tokens automatically
- ✅ Notifies on pull requests

---

## 📱 Best Practices

### ✅ DO
- Use environment variables
- Store secrets in AWS Secrets Manager
- Rotate credentials regularly
- Audit access with CloudTrail
- Encrypt Terraform state in S3
- Use private VPC endpoints

### ❌ DON'T
- Hardcode passwords in source code
- Commit real `.tfvars` files
- Use AWS root credentials
- Expose secrets in logs
- Share credentials through email/chat

---

## 🔍 Security Verification

### Scan vulnerabilities
```bash
# Terraform security scanning
tfsec .

# Checkov
checkov -d .

# Pre-commit
pre-commit run --all-files
```

### Audit current state
```bash
# Check who accessed what
aws cloudtrail lookup-events --max-results 50

# Review security groups
aws ec2 describe-security-groups --query 'SecurityGroups[].{Name:GroupName,Rules:IpPermissions}'

# Verify RDS encryption
aws rds describe-db-instances --query 'DBInstances[].{DBName:DBInstanceIdentifier,Encrypted:StorageEncrypted}'
```

---

## 📞 Reporting Vulnerabilities

If you find a security vulnerability:

1. **DO NOT** publish it in public issues
2. Contact: **luisfernando198912@gmail.com**
3. Describe the issue with details
4. Wait for a response (maximum 48 hours)

---

## 📚 Additional References

- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)
- [Terraform Security Guidelines](https://www.terraform.io/cloud-docs/security)
- [OWASP Cloud Security](https://owasp.org/www-project-cloud-security/)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/cis-benchmarks/)

---

**Last update:** 2026-02-17  
**Version:** 1.0
