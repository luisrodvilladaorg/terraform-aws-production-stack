# ⚡ ASG Module (Auto Scaling Group)

## 📋 Description

This module manages the Auto Scaling Group that provides elastic compute capacity through EC2 Spot instances, optimizing costs while maintaining high availability.

## 🎯 Main Function

Provides a fleet of EC2 instances with automatic scaling based on CPU metrics, using Amazon Linux 2 Spot instances to reduce costs by up to 90%.

## 🏗️ Resources Created

| Resource | Description |
|---------|-------------|
| `data.aws_ami.amazon_linux` | Most recent Amazon Linux 2 AMI (x86_64) |
| `aws_security_group.asg` | Security Group allowing HTTP from ALB and SSH for debugging |
| `aws_launch_template.this` | Launch template with Spot instance configuration |
| `aws_autoscaling_group.this` | Auto Scaling Group distributed across multiple AZs |
| `aws_autoscaling_policy.scale_up` | Scale up policy (CPU > 70%) |
| `aws_autoscaling_policy.scale_down` | Scale down policy (CPU < 30%) |
| `aws_cloudwatch_metric_alarm.high_cpu` | Alarm to trigger scale up |
| `aws_cloudwatch_metric_alarm.low_cpu` | Alarm to trigger scale down |

## 🚀 Features

### Instance Configuration
- **AMI**: Amazon Linux 2 (latest version)
- **Type**: Configurable (default `t3.micro`)
- **Market**: Spot instances for cost optimization
- **IAM Profile**: Includes S3 read permissions

### User Data Script
Instances are automatically configured with:
- ✅ Nginx installed and configured
- ✅ Static content synchronization from S3
- ✅ Health check endpoint at `/`
- ✅ Detailed logs in `/var/log/user-data.log`

### Auto Scaling
- **Min**: 1 instance
- **Max**: 3 instances  
- **Desired**: 1 instance
- **Scale Up**: CPU > 70% for 2 minutes → +1 instance
- **Scale Down**: CPU < 30% for 5 minutes → -1 instance
- **Cooldown**: 300 seconds between scaling actions

## 🔌 Main Inputs

- `vpc_id` - VPC ID
- `private_subnet_ids` - Private subnets for instances
- `instance_type` - EC2 instance type (default: `t3.micro`)
- `instance_profile_name` - IAM instance profile with permissions
- `alb_security_group_id` - ALB security group for HTTP access

## 📤 Important Outputs

- `asg_name` - Auto Scaling Group name
- `asg_arn` - ASG ARN for additional policies
- `launch_template_id` - Launch template ID
- `asg_security_group_id` - Instance security group

## 💰 Cost Optimization

Using Spot instances can reduce costs by up to **90%** compared to On-Demand instances, ideal for interruption-tolerant workloads.

## ⚠️ Considerations

- Spot instances can be interrupted with 2 minutes notice
- User data syncs files from S3 on each boot
- SSH is open from Internet (0.0.0.0/0) - consider restricting in production
