# 🪣 S3 Module (Simple Storage Service)

## 📋 Description

This module manages the S3 buckets required for the project: one for static web content (HTML, CSS, JS, images) and another for Application Load Balancer access logs.

## 🎯 Main Function

Provides highly available and durable object storage to serve static content and centralize ALB logs with appropriate access policies.

## 🏗️ Resources Created

| Resource | Description |
|---------|-------------|
| `aws_s3_bucket.static` | Bucket for web application static content |
| `aws_s3_bucket.alb_logs` | Bucket for ALB access logs |
| `aws_s3_bucket_policy.alb_logs` | Policy allowing ALB to write logs |
| `aws_s3_object.static_files` | Automatic upload of static files to bucket |
| `data.aws_elb_service_account` | ELB service account for policies |

## 📦 Buckets Created

### 1. Static Content Bucket
**Name**: `{project}-{environment}-static`  
**Purpose**: Store and serve static content

- HTML, CSS, JavaScript
- Images, videos, fonts
- Frontend configuration files

**Features**:
- ✅ Automatic upload from local directory
- ✅ ETags for change detection
- ✅ Force destroy enabled (dev)

### 2. ALB Logs Bucket
**Name**: `{project}-{environment}-alb-logs`  
**Purpose**: Centralize ALB access logs

- Records of all HTTP requests
- Traffic analysis and patterns
- Security auditing
- Error troubleshooting

**Features**:
- ✅ Policy allowing writes from ELB
- ✅ Automatic organization by date
- ✅ Compatible with analysis tools (Athena, QuickSight)

## 🔐 Access Policies

### ALB Logs Policy
```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::009996457667:root"  // ELB Service Account
  },
  "Action": "s3:PutObject",
  "Resource": "arn:aws:s3:::...-alb-logs/*"
}
```

This policy allows **only the ELB service** to write logs to the bucket.

## 📁 Automatic File Upload

The module automatically syncs local files to S3:

```hcl
for_each = fileset(var.static_site_path, "**/*")
```

- **Recursive**: Uploads entire directory structure
- **ETags**: Only updates modified files
- **Preserves structure**: Maintains relative paths

## 🔌 Main Inputs

- `project_name` - Project name (part of bucket name)
- `environment` - Environment (dev/staging/prod)
- `static_site_path` - Local path to static files directory
- `force_destroy` - Allow bucket deletion with objects (default: false)

## 📤 Important Outputs

- `static_bucket_name` - Static content bucket name
- `static_bucket_arn` - Static bucket ARN (for IAM policies)
- `logs_bucket_name` - ALB logs bucket name
- `static_bucket_domain` - Bucket regional domain name

## 🚀 Workflow

```
┌──────────────────┐
│  Local Files     │
│  (state-site/)   │
└────────┬─────────┘
         │ Terraform Apply
         ↓
┌──────────────────┐
│  S3 Bucket       │
│  static/         │
└────────┬─────────┘
         │ EC2 User Data
         ↓
┌──────────────────┐
│  EC2 Instances   │
│  aws s3 sync     │
└──────────────────┘
```

## ✅ Best Practices

- ✅ Separate buckets for different purposes (static vs logs)
- ✅ Specific bucket policies following least privilege
- ✅ ETags prevent unnecessary uploads
- ✅ Enables ALB access logging for compliance

## 📝 Notes

- Force destroy is enabled in dev for easier cleanup
- Consider enabling versioning in production
- ALB logs are organized automatically by AWS
- Can integrate with CloudFront for CDN distribution

## 🔜 Future Enhancements

- [ ] Enable S3 bucket versioning for rollback
- [ ] Configure lifecycle policies for log rotation
- [ ] Add server-side encryption (SSE-S3 or KMS)
- [ ] Implement bucket replication for DR
- [ ] Add CloudFront distribution for static content
