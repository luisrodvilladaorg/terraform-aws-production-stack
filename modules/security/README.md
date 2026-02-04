# 🔒 Security Module

## 📋 Description

This module is prepared to centralize and manage all infrastructure security aspects, including advanced security groups, Network ACLs, AWS WAF, and AWS Security Hub configurations.

## 🎯 Main Function

Provide a comprehensive security layer to protect infrastructure against threats, implement granular access controls, and maintain compliance with security standards.

## 🏗️ Planned Resources

| Resource | Description |
|---------|-------------|
| `aws_wafv2_web_acl` | Web Application Firewall to protect ALB |
| `aws_wafv2_rule_group` | Custom WAF rule groups |
| `aws_network_acl` | Network ACLs for subnet-level traffic control |
| `aws_security_group_rule` | Additional security group rules |
| `aws_guardduty_detector` | Threat detection with GuardDuty |
| `aws_config_rule` | Automated compliance rules |
| `aws_kms_key` | KMS keys for at-rest encryption |

## 🛡️ Security Layers

```
┌────────────────────────────────────────────────┐
│  Layer 7: WAF (Application)                   │
│  • SQL Injection protection                   │
│  • XSS protection                             │
│  • Rate limiting                              │
│  • Geo-blocking                               │
└────────────────────────────────────────────────┘
                      ↓
┌────────────────────────────────────────────────┐
│  Layer 4: Security Groups (Stateful)          │
│  • ALB SG: 80/443 from Internet               │
│  • ASG SG: 80 from ALB only                   │
│  • RDS SG: 5432 from ASG only                 │
└────────────────────────────────────────────────┘
                      ↓
┌────────────────────────────────────────────────┐
│  Layer 3: Network ACLs (Stateless)            │
│  • Public subnet: 80, 443, 1024-65535         │
│  • Private subnet: Limited egress             │
└────────────────────────────────────────────────┘
```

## 🚨 WAF - Web Application Firewall

### Recommended Rules

#### 1. Core Rule Set (CRS)
- ✅ SQL Injection prevention
- ✅ Cross-Site Scripting (XSS)
- ✅ Local File Inclusion (LFI)
- ✅ Remote File Inclusion (RFI)

#### 2. Rate Limiting
```
┌──────────────────────────────────────┐
│  100 requests/5min per IP            │
│  L7 DDoS protection                  │
└──────────────────────────────────────┘
```

#### 3. Known Bad Inputs
- Known malicious payloads
- Malicious bot user agents
- Common attack patterns

#### 4. Geo-Blocking (Optional)
```
Allow: EU, US
Block: Known attack source countries
```

## 🔐 Network ACLs

### Public Subnets
```
Inbound:
  80    (HTTP)      → Allow from 0.0.0.0/0
  443   (HTTPS)     → Allow from 0.0.0.0/0
  1024-65535        → Allow (return traffic)

Outbound:
  All               → Allow
```

### Private Subnets
```
Inbound:
  All from VPC CIDR → Allow
  Deny all else

Outbound:
  All to VPC CIDR   → Allow
  80/443 Internet   → Allow (updates, APIs)
```

## �� GuardDuty - Threat Detection

Continuous monitoring for:
- Unusual API calls
- Potentially compromised instances
- Reconnaissance attempts
- Cryptocurrency mining
- Malware
- Backdoors

## 📊 AWS Config - Compliance

Automated rules to ensure:
- ✅ S3 buckets are encrypted
- ✅ RDS instances have backups
- ✅ Security groups don't allow 0.0.0.0/0 SSH
- ✅ Root account MFA enabled
- ✅ CloudTrail enabled

## 🔑 KMS - Encryption

Encryption keys for:
- RDS databases (at-rest)
- S3 buckets (SSE-KMS)
- EBS volumes (EC2)
- Secrets Manager
- Parameter Store

## 🔌 Planned Inputs

- `project_name` - Project name
- `environment` - Environment (dev/staging/prod)
- `alb_arn` - ALB ARN to attach WAF
- `vpc_id` - VPC ID for NACLs
- `enable_waf` - Enable WAF (default: true for prod)
- `enable_guardduty` - Enable GuardDuty (default: true)

## 📤 Planned Outputs

- `waf_web_acl_arn` - WAF Web ACL ARN
- `kms_key_ids` - Map of KMS key IDs
- `guardduty_detector_id` - GuardDuty detector ID
- `config_rules` - List of active Config rules

## 📝 Implementation Status

This module is currently a **placeholder** for future security enhancements. Current security is implemented directly in other modules:

- **ALB module**: Security group for HTTP traffic
- **ASG module**: Security group for EC2 instances
- **RDS module**: Security group for database access
- **Networking module**: Base security group

## 🔜 Roadmap

### Phase 1: Essential Security
- [ ] Implement WAF with core rules
- [ ] Configure Network ACLs for public/private subnets
- [ ] Enable GuardDuty for threat detection
- [ ] Setup KMS keys for encryption

### Phase 2: Compliance
- [ ] Activate AWS Config rules
- [ ] Integrate Security Hub
- [ ] Configure AWS Inspector for vulnerability scanning
- [ ] Setup centralized logging with CloudWatch

### Phase 3: Advanced Protection
- [ ] Implement custom WAF rules
- [ ] Add DDoS protection with Shield Advanced
- [ ] Configure Secrets Manager rotation
- [ ] Implement VPC Flow Logs analysis

## 🏆 Security Best Practices

- ✅ Defense in depth (multiple security layers)
- ✅ Principle of least privilege (minimal permissions)
- ✅ Encryption at rest and in transit
- ✅ Continuous monitoring and logging
- ✅ Automated compliance checking
- ✅ Regular security assessments
