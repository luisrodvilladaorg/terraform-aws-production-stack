🌐 Terraform AWS Production Stack

A fully modular, production‑ready AWS infrastructure built with Terraform
This project provisions a complete production‑grade AWS architecture using Terraform, following industry best practices for modularity, scalability, security, and maintainability.
It is designed to simulate the type of infrastructure used in real companies, making it ideal for DevOps/Cloud Engineering portfolios.


🚀 What This Infrastructure Includes
🔹 VPC & Networking
A fully isolated network layout:

Custom VPC (10.0.0.0/16)

Public and private subnets across multiple AZs

Internet Gateway for public ingress

NAT Gateway for secure outbound traffic from private subnets

Route tables and associations

🔹 Load Balancing & High Availability
Application Load Balancer (ALB)

Target Groups & listeners

Health checks

Multi‑AZ design for resilience

🔹 Compute Layer
Auto Scaling Group (ASG)

Launch Template for EC2 configuration

Private subnets for backend instances

Security groups with least‑privilege rules

🔹 State Management (Production‑Ready)
Remote backend stored in S3

State locking with DynamoDB

Encrypted state files

Environment‑specific state separation (dev, prod)

🔹 Monitoring & Logging
CloudWatch metrics and log groups

ASG and EC2 monitoring

ALB access logs (optional)

🔹 Modular Architecture
Each major component is isolated into its own Terraform module:

modules/
  vpc/
  alb/
  asg/
  ec2/
  security/
  networking/
  monitoring/
envs/
  dev/
  prod/

This structure mirrors real enterprise Terraform repositories and supports long‑term scalability.

User
 |
 v
[ ALB ]
 |        \
 v         v
[ ASG ]   [ EC2 ]
   |         |
   +----> [ RDS ]
   |
   +----> [ S3 Web ]

Terraform
 |
 v
[ S3 State ] --- [ DynamoDB Lock ]


⚙️ How to Deploy
1. Choose an environment

cd envs/dev

2. Initialize Terraform
terraform init

3. Review the plan
terraform plan

4. Apply the infrastructure
terraform apply

🎯 Why This Project Matters
This repository demonstrates real‑world skills expected from a DevOps or Cloud Engineer, including:

Infrastructure as Code (IaC) with Terraform

Modular and environment‑based architecture

AWS networking fundamentals

High‑availability compute design

Load balancing and autoscaling

Remote state management

Security best practices

Production‑ready folder structure

It is intentionally designed to reflect how modern companies structure their cloud infrastructure.