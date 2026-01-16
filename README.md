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

Best practices for security

Production‑ready folder structure

It is intentionally designed to reflect how modern companies structure their cloud infrastructure.


🔄 CI/CD Workflow (Terraform)

This project uses GitHub Actions with a self-hosted runner to implement a clean and production-oriented CI/CD workflow for Terraform.

The pipeline is intentionally split into three responsibilities to avoid accidental infrastructure changes and to follow real enterprise practices.

📁 Workflow

.github/workflows/terraform-ci.yml

Continuous Integration (CI)

Trigger

On push and pull_request to main

Purpose

Validate Terraform code quality

Ensure changes are safe before deployment

Steps

terraform init

terraform validate

terraform plan

❌ No infrastructure changes are applied during CI.

📁 Workflow

.github/workflows/terraform-cd.yml



                           ┌────────────────────────────┐
                           │            User            │
                           │        Browser / Client    │
                           └───────────────┬────────────┘
                                           │
                                           ▼
                           ┌────────────────────────────┐
                           │      Application Load      │
                           │      Balancer (ALB)        │
                           └───────────────┬────────────┘
                                           │
                 ┌─────────────────────────┼─────────────────────────┐
                 │                         │                         │
                 ▼                         ▼                         ▼
     ┌────────────────────┐   ┌────────────────────┐   ┌────────────────────┐
     │   Auto Scaling       │   │   Auto Scaling       │   │    Legacy EC2  │
     │   Group (Spot EC2)   │   │   Group (Spot EC2)   │   │   (On-Demand)  │
     └───────────┬────────┘   └───────────┬────────┘   └───────────┬────────┘
                 │                         │                         │
                 ├───────────────┬─────────┴─────────┬───────────────┤
                                 │                   │
                                 ▼                   ▼
                       ┌────────────────────┐  ┌────────────────────┐
                       │   RDS PostgreSQL    │  │   RDS PostgreSQL    │
                       │  (Private Subnets) │  │  (Private Subnets) │
                       └────────────────────┘  └────────────────────┘

                 ┌──────────────────────────────────────────────────────────┐
                 │                         AWS Services                     │
                 │                                                          │
                 │   ┌──────────────┐   ┌──────────────────┐               │
                 │   │  S3 Bucket   │   │  SSM Parameter    │              │
                 │   │ Static Web   │   │  Store            │              │
                 │   └──────┬───────┘   └─────────┬────────┘               │
                 │          │                     │                        │
                 │          ▼                     ▼                        │
                 │   ┌──────────────┐   ┌──────────────────┐               │
                 │   │ EC2 / ASG    │   │   EC2 / ASG       │              │
                 │   │ Read Web     │   │   Read DB Creds  │               │
                 │   └──────────────┘   └──────────────────┘               │
                 │                                                         │
                 │   ┌──────────────────┐   ┌──────────────────────────┐  │
                 │   │ Terraform State  │   │ DynamoDB State Locks     │  │
                 │   │ S3 Backend       │   │                          │  │
                 │   └─────────┬────────┘   └─────────┬────────────────┘  │
                 │             │                      │                   │
                 │             ▼                      ▼                   │
                 │   ┌──────────────────┐   ┌──────────────────────────┐  │
                 │   │   Terraform CLI  │──▶│   Locking / State Mgmt  │  │
                 │   └──────────────────┘   └──────────────────────────┘  │
                 └──────────────────────────────────────────────────────────┘



                        
