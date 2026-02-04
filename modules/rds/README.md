# 🗄️ RDS Module (Relational Database Service)

## 📋 Description

This module manages the PostgreSQL managed database in AWS RDS, providing persistent and reliable storage for application data with automatic backups.

## 🎯 Main Function

Provides a PostgreSQL 15 database in high availability within private subnets, accessible only from Auto Scaling Group EC2 instances.

## 🏗️ Resources Created

| Resource | Description |
|---------|-------------|
| `aws_security_group.rds` | Security Group allowing only PostgreSQL (5432) from ASG |
| `aws_db_subnet_group.this` | Subnet group with private subnets for RDS |
| `aws_db_instance.this` | PostgreSQL 15 instance in db.t3.micro class |

## 🔧 Technical Specifications

### Database
- **Engine**: PostgreSQL
- **Version**: 15.15
- **Class**: db.t3.micro (2 vCPU, 1 GB RAM)
- **Storage**: 20 GB gp2 (General Purpose SSD)
- **Multi-AZ**: No (dev environment, enable in prod)

### Network Configuration
- **Public Access**: Disabled (private only)
- **Subnets**: Private across multiple AZs
- **Port**: 5432 (PostgreSQL default)
- **Access**: Only from ASG security group

## 🔐 Security

```
┌──────────────────────────────────────┐
│     Auto Scaling Group Instances    │
│     (Security Group: ASG-SG)         │
└──────────┬───────────────────────────┘
           │ ✅ Port 5432
           │ Allowed
           ↓
┌──────────────────────────────────────┐
│   RDS PostgreSQL Instance            │
│   (Security Group: RDS-SG)           │
│   ❌ Internet: Blocked               │
└──────────────────────────────────────┘
```

### Security Group Rules
- **Ingress**: Only port 5432 from ASG security group
- **Egress**: All traffic allowed
- **Internet**: Completely isolated (publicly_accessible = false)

## 🔌 Main Inputs

- `vpc_id` - VPC ID
- `private_subnet_ids` - Private subnets for subnet group
- `asg_security_group_id` - ASG security group for access
- `db_name` - Database name (default: `appdb`)
- `db_user` - PostgreSQL master user
- `db_password` - Password (sensitive, not logged)

## 📤 Important Outputs

- `db_endpoint` - Connection endpoint (hostname:port)
- `db_address` - Hostname only (for DNS configuration)
- `db_port` - PostgreSQL port (5432)
- `db_name` - Database name
- `db_security_group_id` - RDS security group ID

## 🔗 Connection String

Applications can connect using:

```bash
postgresql://[db_user]:[db_password]@[db_endpoint]/[db_name]
```

Example:
```bash
postgresql://appuser:SecurePass@terraform-aws-stack-dev-postgres.xxxxx.eu-west-3.rds.amazonaws.com:5432/appdb
```

## 💾 Backups and Recovery

- **Final Snapshot**: Disabled (skip_final_snapshot = true)
- **Retention**: Configure in production (retention days)
- **Backup Window**: Automatic during low-traffic period

## ⚠️ Considerations

### Development
- ✅ `skip_final_snapshot = true` - OK for dev/test
- ✅ Small instance class - Cost optimized
- ✅ Single-AZ - Sufficient for development

### Production
- 🔄 Enable Multi-AZ for high availability
- 🔄 Increase instance class (db.t3.medium or larger)
- 🔄 Enable automated backups with retention
- 🔄 Configure maintenance windows
- 🔄 Enable deletion protection
- 🔄 Use Secrets Manager for credentials
