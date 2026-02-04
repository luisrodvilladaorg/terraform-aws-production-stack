# 🔐 IAM Module (Identity and Access Management)

## 📋 Description

This module manages the IAM roles, policies, and instance profiles required for EC2 instances to securely access AWS resources, specifically S3 buckets.

## 🎯 Main Function

Provides secure identity and permissions to EC2 instances to access static content in S3 without embedded credentials.

## 🏗️ Resources Created

| Resource | Description |
|---------|-------------|
| `aws_iam_role.ec2` | IAM role that EC2 instances can assume |
| `aws_iam_role_policy.s3_read` | Inline policy with S3 read permissions |
| `aws_iam_instance_profile.ec2` | Instance profile to attach the role to EC2 |

## 🔑 Granted Permissions

### S3 Read-Only Policy
```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",    // Download objects
    "s3:ListBucket"    // List bucket contents
  ],
  "Resource": [
    "arn:aws:s3:::terraform-aws-stack-dev-static",
    "arn:aws:s3:::terraform-aws-stack-dev-static/*"
  ]
}
```

## 🛡️ Trust Policy

The role allows **only the EC2 service** to assume it:
```json
{
  "Principal": {
    "Service": "ec2.amazonaws.com"
  },
  "Action": "sts:AssumeRole"
}
```

## 🔌 Main Inputs

- `project_name` - Project name for naming
- `environment` - Environment (dev/staging/prod)
- `tags` - Additional tags for IAM resources

## 📤 Important Outputs

- `instance_profile_name` - Instance profile name to use in launch templates
- `instance_role_arn` - IAM role ARN
- `instance_role_name` - Role name to attach additional policies

## 🎯 Typical Usage

This module is used in conjunction with the ASG module:

1. **ASG** creates EC2 instances with the instance profile
2. Instances automatically assume the **IAM role**
3. User data can execute `aws s3 sync` without credentials
4. Applications can access S3 securely

## ✅ Best Practices

- ✅ Uses IAM roles instead of embedded access keys
- ✅ Follows principle of least privilege (S3 read only)
- ✅ Permissions are specific to the project bucket
- ✅ Allows complete audit via CloudTrail

## 📝 Notes

- The instance profile is the way to attach IAM roles to EC2 instances
- Temporary credentials are automatically rotated by AWS
- Currently configured for dev bucket, adjust for staging/prod
