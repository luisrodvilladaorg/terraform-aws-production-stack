# 🌐 Networking Module (VPC and Subnets)

## �� Description

This module creates all the base network infrastructure in AWS, including VPC, public and private subnets distributed across multiple availability zones, ensuring high availability and network isolation.

## 🎯 Main Function

Establishes the network foundation for the entire infrastructure, segregating public resources (ALB) from private ones (EC2, RDS) with appropriate Internet routing.

## 🏗️ Resources Created

| Resource | Description |
|---------|-------------|
| `aws_vpc.this` | Main VPC with DNS enabled |
| `aws_internet_gateway.this` | Internet Gateway for public access |
| `aws_subnet.public` | 3 public subnets (one per AZ) |
| `aws_subnet.private` | 3 private subnets (one per AZ) |
| `aws_route_table.public` | Public route table with Internet route |
| `aws_route_table_association.public` | Subnet-route table associations |
| `aws_security_group.base` | Temporary base security group (HTTP baseline) |

## 🗺️ Network Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    VPC (10.0.0.0/16)                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─── Public Subnets (Internet-facing) ───┐            │
│  │  • 10.0.1.0/24  (eu-west-3a)          │            │
│  │  • 10.0.2.0/24  (eu-west-3b)          │            │
│  │  • 10.0.3.0/24  (eu-west-3c)          │            │
│  │  ↓ Internet Gateway ↓                  │            │
│  └────────────────────────────────────────┘            │
│                                                         │
│  ┌─── Private Subnets (No Internet) ─────┐            │
│  │  • 10.0.11.0/24 (eu-west-3a)          │            │
│  │  • 10.0.12.0/24 (eu-west-3b)          │            │
│  │  • 10.0.13.0/24 (eu-west-3c)          │            │
│  │  (EC2, RDS)                            │            │
│  └────────────────────────────────────────┘            │
└─────────────────────────────────────────────────────────┘
```

## 📊 Subnet Distribution

### Public Subnets
- **Purpose**: ALB, Bastion hosts, NAT Gateways
- **Internet**: Direct access via Internet Gateway
- **Public IPs**: Auto-assigned on launch

### Private Subnets  
- **Purpose**: EC2 instances, RDS databases
- **Internet**: No direct access (higher security)
- **Communication**: Only within VPC

## 🔌 Main Inputs

- `vpc_cidr` - VPC CIDR block (default: `10.0.0.0/16`)
- `public_subnet_cidrs` - List of CIDRs for public subnets
- `private_subnet_cidrs` - List of CIDRs for private subnets
- `availability_zones` - AZs where subnets will be created

## 📤 Important Outputs

- `vpc_id` - Created VPC ID
- `public_subnet_ids` - Public subnet IDs for ALB
- `private_subnet_ids` - Private subnet IDs for EC2/RDS
- `base_security_group_id` - Base security group

## ✅ Features

- ✅ **Multi-AZ**: High availability across 3 zones
- ✅ **DNS**: DNS resolution enabled in VPC
- ✅ **Segregation**: Clear public/private separation
- ✅ **Scalability**: /16 allows ~65,000 IPs

## 🔒 Security

- Private subnets have no direct Internet access
- Base security group allows HTTP (80)
- Each tier (ALB, EC2, RDS) has its own specific security group

## 📝 Future Improvements

- [ ] Add NAT Gateway for outbound from private subnets
- [ ] Implement Network ACLs for additional security layer
- [ ] VPC Flow Logs for traffic auditing
- [ ] VPC Endpoints for AWS services (S3, DynamoDB)
