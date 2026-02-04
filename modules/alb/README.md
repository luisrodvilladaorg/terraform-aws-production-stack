# 🔀 ALB Module (Application Load Balancer)

## 📋 Description

This module manages the complete configuration of the AWS Application Load Balancer, which acts as an HTTP entry point to distribute incoming traffic among the Auto Scaling Group EC2 instances.

## 🎯 Main Function

Provides application-level load balancing (layer 7) with path-based routing capabilities, automatic health checks, and access logging to S3.

## 🏗️ Resources Created

| Resource | Description |
|---------|-------------|
| `aws_security_group.alb` | Security Group allowing HTTP traffic (port 80) from Internet |
| `aws_lb.this` | Application Load Balancer in public subnets with logging enabled |
| `aws_lb_target_group.this` | Main target group for EC2 instances with HTTP health checks |
| `aws_lb_target_group.ecs` | Secondary target group for ECS containers (IP targets) |
| `aws_lb_listener.http` | HTTP listener on port 80 forwarding to main target group |
| `aws_lb_listener_rule.ecs` | Routing rule for `/ecs*` paths to ECS |
| `aws_autoscaling_attachment.this` | Association between ALB and Auto Scaling Group |

## 🔌 Main Inputs

- `vpc_id` - VPC ID where the ALB will be deployed
- `public_subnet_ids` - Public subnets for the ALB (minimum 2 AZs)
- `asg_name` - Auto Scaling Group name to associate
- `alb_logs_bucket_name` - S3 bucket to store access logs

## 📤 Important Outputs

- `alb_dns_name` - ALB public DNS for application access
- `target_group_arn` - Target group ARN for additional configurations
- `alb_security_group_id` - Security group ID for cross-references

## ✅ Health Check

- **Path**: `/`
- **Protocol**: HTTP
- **Interval**: 30 seconds
- **Timeout**: 5 seconds
- **Thresholds**: 2 consecutive checks (healthy/unhealthy)

## 📝 Notes

- The ALB logs all accesses to the configured S3 bucket under the `alb/` prefix
- Supports dual routing: main traffic to EC2 and `/ecs*` traffic to containers
- Security groups are configured to allow public HTTP traffic
