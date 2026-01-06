# Terraform AWS Production Stack

This project provisions a **production-like AWS infrastructure** using Terraform, following real-world cloud and DevOps best practices.

The goal is to demonstrate a **fully reproducible, automated infrastructure and deployment workflow**, where a complete web platform can be created from scratch using a single `terraform apply`.

---

## 🚀 Project Overview

The infrastructure delivers a static web application through **EC2 instances managed by an Auto Scaling Group**, fronted by an **Application Load Balancer**.

Static assets are stored in **Amazon S3** and automatically deployed to EC2 instances at launch time via **user-data**, without any manual steps or SSH access.

The platform includes **observability**, **access logging**, and **cost-aware design decisions**, making it suitable as a professional portfolio project.

---

## 🧱 Architecture

### Core Components

- **Networking**
  - Custom VPC
  - 3 public subnets
  - 3 private subnets
  - Multi-AZ design (eu-west-3)

- **Compute**
  - Auto Scaling Group
  - Launch Template
  - Spot Instances (cost optimized)
  - Stateless EC2 instances

- **Load Balancing**
  - Application Load Balancer (HTTP)
  - Health checks
  - Traffic distribution across instances

- **Storage**
  - S3 bucket for static website assets
  - S3 bucket for ALB access logs
  - No public buckets

- **IAM & Security**
  - IAM role attached to EC2 instances
  - Least-privilege access to S3
  - Security Groups managed via Terraform

- **Observability**
  - ALB access logs stored in S3
  - Infrastructure fully auditable

---

## 🔄 Deployment Flow (End-to-End)

06/01
RDS working
Web static working
Next step backend


