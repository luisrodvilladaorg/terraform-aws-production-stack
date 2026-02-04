# 📊 CloudWatch Module

## 📋 Description

This module is prepared to manage Amazon CloudWatch resources, including custom metrics, alarms, dashboards, and logs for infrastructure monitoring and observability.

## 🎯 Main Function

Provide monitoring, alerting, and visualization capabilities for all AWS infrastructure components, enabling proactive problem detection and response.

## 🏗️ Planned Resources

| Resource | Description |
|---------|-------------|
| `aws_cloudwatch_dashboard` | Custom dashboards for metrics visualization |
| `aws_cloudwatch_metric_alarm` | Alarms based on metric thresholds |
| `aws_cloudwatch_log_group` | Log groups to centralize logging |
| `aws_cloudwatch_log_stream` | Service-specific log streams |
| `aws_cloudwatch_event_rule` | EventBridge rules for automation |

## 📈 Metrics to Monitor

### ALB (Application Load Balancer)
- Request count per second
- Target response time
- HTTP 4xx/5xx error rates
- Healthy/Unhealthy target count
- Active connection count

### Auto Scaling Group
- CPU utilization
- Network in/out
- Disk read/write operations
- Status check failures
- Instance count (min/max/desired)

### RDS (PostgreSQL)
- Database connections
- CPU utilization
- Free storage space
- Read/Write IOPS
- Replica lag (if Multi-AZ)

### S3 Buckets
- Bucket size bytes
- Number of objects
- All requests (GET, PUT, etc)
- 4xx/5xx errors

## 🚨 Recommended Alarms

```
┌─────────────────────────────────────────────────┐
│  CRITICAL (SNS → Email/SMS)                     │
├─────────────────────────────────────────────────┤
│  • ALB 5xx errors > 10 (5 min)                  │
│  • ASG all instances unhealthy                  │
│  • RDS CPU > 90% (15 min)                       │
│  • RDS Storage < 10% free                       │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  WARNING (CloudWatch Dashboard)                 │
├─────────────────────────────────────────────────┤
│  • ALB response time > 500ms (10 min)           │
│  • ASG CPU > 80% (5 min)                        │
│  • RDS connections > 80% max                    │
└─────────────────────────────────────────────────┘
```

## 📊 Suggested Dashboard

```
┌──────────────────────────────────────────────────────────┐
│                 Production Stack Dashboard               │
├────────────────────┬─────────────────────────────────────┤
│  ALB Requests      │  ALB Response Time                  │
│  [Line Chart]      │  [Line Chart]                       │
├────────────────────┼─────────────────────────────────────┤
│  ASG Instances     │  ASG CPU Utilization                │
│  [Number Widget]   │  [Gauge]                            │
├────────────────────┼─────────────────────────────────────┤
│  RDS Connections   │  RDS CPU                            │
│  [Stacked Area]    │  [Line Chart]                       │
├────────────────────┴─────────────────────────────────────┤
│  Recent Alarms                                           │
│  [Alarm List]                                            │
└──────────────────────────────────────────────────────────┘
```

## 🔌 Planned Inputs

- `project_name` - Project name
- `environment` - Environment (dev/staging/prod)
- `alb_arn` - ALB ARN for metrics
- `asg_name` - ASG name for alarms
- `rds_identifier` - RDS identifier
- `sns_topic_arn` - SNS topic for notifications

## 📤 Planned Outputs

- `dashboard_arn` - CloudWatch dashboard ARN
- `alarm_arns` - Map of all created alarm ARNs
- `log_group_names` - List of created log group names

## 📝 Implementation Notes

This module is currently a placeholder for future monitoring implementation. When activated, it will provide:

- Comprehensive dashboards for all infrastructure components
- Automated alerting via SNS topics
- Centralized logging for troubleshooting
- EventBridge integration for automated responses

## 🔜 Roadmap

- [ ] Create base dashboard with ALB, ASG, and RDS metrics
- [ ] Implement critical and warning alarms
- [ ] Setup log groups for application logs
- [ ] Configure log retention policies
- [ ] Integrate with SNS for notifications
- [ ] Add custom metrics for application-specific monitoring
